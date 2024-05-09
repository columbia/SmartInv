1 library SafeMath {
2   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
3     uint256 c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function div(uint256 a, uint256 b) internal constant returns (uint256) {
9     // assert(b > 0); // Solidity automatically throws when dividing by 0
10     uint256 c = a / b;
11     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ERC20Basic {
28   uint256 public totalSupply;
29   function balanceOf(address who) constant returns (uint256);
30   function transfer(address to, uint256 value) returns (bool);
31   event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 contract BasicToken is ERC20Basic {
35   using SafeMath for uint256;
36 
37   mapping(address => uint256) balances;
38 
39   /**
40   * @dev transfer token for a specified address
41   * @param _to The address to transfer to.
42   * @param _value The amount to be transferred.
43   */
44   function transfer(address _to, uint256 _value) returns (bool) {
45     balances[msg.sender] = balances[msg.sender].sub(_value);
46     balances[_to] = balances[_to].add(_value);
47     Transfer(msg.sender, _to, _value);
48     return true;
49   }
50 
51   /**
52   * @dev Gets the balance of the specified address.
53   * @param _owner The address to query the the balance of.
54   * @return An uint256 representing the amount owned by the passed address.
55   */
56   function balanceOf(address _owner) constant returns (uint256 balance) {
57     return balances[_owner];
58   }
59 
60 }
61 
62 contract ERC20 is ERC20Basic {
63   function allowance(address owner, address spender) constant returns (uint256);
64   function transferFrom(address from, address to, uint256 value) returns (bool);
65   function approve(address spender, uint256 value) returns (bool);
66   event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 contract StandardToken is ERC20, BasicToken {
70 
71   mapping (address => mapping (address => uint256)) allowed;
72 
73 
74   /**
75    * @dev Transfer tokens from one address to another
76    * @param _from address The address which you want to send tokens from
77    * @param _to address The address which you want to transfer to
78    * @param _value uint256 the amout of tokens to be transfered
79    */
80   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
81     var _allowance = allowed[_from][msg.sender];
82 
83     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
84     // require (_value <= _allowance);
85 
86     balances[_to] = balances[_to].add(_value);
87     balances[_from] = balances[_from].sub(_value);
88     allowed[_from][msg.sender] = _allowance.sub(_value);
89     Transfer(_from, _to, _value);
90     return true;
91   }
92 
93   /**
94    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
95    * @param _spender The address which will spend the funds.
96    * @param _value The amount of tokens to be spent.
97    */
98   function approve(address _spender, uint256 _value) returns (bool) {
99 
100     // To change the approve amount you first have to reduce the addresses`
101     //  allowance to zero by calling `approve(_spender, 0)` if it is not
102     //  already 0 to mitigate the race condition described here:
103     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
104     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
105 
106     allowed[msg.sender][_spender] = _value;
107     Approval(msg.sender, _spender, _value);
108     return true;
109   }
110 
111   /**
112    * @dev Function to check the amount of tokens that an owner allowed to a spender.
113    * @param _owner address The address which owns the funds.
114    * @param _spender address The address which will spend the funds.
115    * @return A uint256 specifing the amount of tokens still avaible for the spender.
116    */
117   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
118     return allowed[_owner][_spender];
119   }
120 
121 }
122 
123 contract HeroCoin is StandardToken {
124 
125     // data structures
126     enum States {
127     Initial, // deployment time
128     ValuationSet,
129     Ico, // whitelist addresses, accept funds, update balances
130     Underfunded, // ICO time finished and minimal amount not raised
131     Operational, // manage contests
132     Paused         // for contract upgrades
133     }
134 
135     //should be constant, but is not, to avoid compiler warning
136     address public  rakeEventPlaceholderAddress = 0x0000000000000000000000000000000000000000;
137 
138     string public constant name = "Herocoin";
139 
140     string public constant symbol = "PLAY";
141 
142     uint8 public constant decimals = 18;
143 
144     mapping (address => bool) public whitelist;
145 
146     address public initialHolder;
147 
148     address public stateControl;
149 
150     address public whitelistControl;
151 
152     address public withdrawControl;
153 
154     States public state;
155 
156     uint256 public weiICOMinimum;
157 
158     uint256 public weiICOMaximum;
159 
160     uint256 public silencePeriod;
161 
162     uint256 public startAcceptingFundsBlock;
163 
164     uint256 public endBlock;
165 
166     uint256 public ETH_HEROCOIN; //number of herocoins per ETH
167 
168     mapping (address => uint256) lastRakePoints;
169 
170 
171     uint256 pointMultiplier = 1e18; //100% = 1*10^18 points
172     uint256 totalRakePoints; //total amount of rakes ever paid out as a points value. increases monotonically, but the number range is 2^256, that's enough.
173     uint256 unclaimedRakes; //amount of coins unclaimed. acts like a special entry to balances
174     uint256 constant percentForSale = 30;
175 
176     mapping (address => bool) public contests; // true if this address holds a contest
177 
178     //this creates the contract and stores the owner. it also passes in 3 addresses to be used later during the lifetime of the contract.
179     function HeroCoin(address _stateControl, address _whitelistControl, address _withdraw, address _initialHolder) {
180         initialHolder = _initialHolder;
181         stateControl = _stateControl;
182         whitelistControl = _whitelistControl;
183         withdrawControl = _withdraw;
184         moveToState(States.Initial);
185         weiICOMinimum = 0;
186         //to be overridden
187         weiICOMaximum = 0;
188         endBlock = 0;
189         ETH_HEROCOIN = 0;
190         totalSupply = 2000000000 * pointMultiplier;
191         //sets the value in the superclass.
192         balances[initialHolder] = totalSupply;
193         //initially, initialHolder has 100%
194     }
195 
196     event ContestAnnouncement(address addr);
197 
198     event Whitelisted(address addr);
199 
200     event Credited(address addr, uint balance, uint txAmount);
201 
202     event StateTransition(States oldState, States newState);
203 
204     modifier onlyWhitelist() {
205         require(msg.sender == whitelistControl);
206         _;
207     }
208 
209     modifier onlyOwner() {
210         require(msg.sender == initialHolder);
211         _;
212     }
213 
214     modifier onlyStateControl() {
215         require(msg.sender == stateControl);
216         _;
217     }
218 
219     modifier onlyWithdraw() {
220         require(msg.sender == withdrawControl);
221         _;
222     }
223 
224     modifier requireState(States _requiredState) {
225         require(state == _requiredState);
226         _;
227     }
228 
229     /**
230     BEGIN ICO functions
231     */
232 
233     //this is the main funding function, it updates the balances of Herocoins during the ICO.
234     //no particular incentive schemes have been implemented here
235     //it is only accessible during the "ICO" phase.
236     function() payable
237     requireState(States.Ico)
238     {
239         require(whitelist[msg.sender] == true);
240         require(this.balance <= weiICOMaximum); //note that msg.value is already included in this.balance
241         require(block.number < endBlock);
242         require(block.number >= startAcceptingFundsBlock);
243         uint256 heroCoinIncrease = msg.value * ETH_HEROCOIN;
244         balances[initialHolder] -= heroCoinIncrease;
245         balances[msg.sender] += heroCoinIncrease;
246         Credited(msg.sender, balances[msg.sender], msg.value);
247     }
248 
249     function moveToState(States _newState)
250     internal
251     {
252         StateTransition(state, _newState);
253         state = _newState;
254     }
255 
256     // ICO contract configuration function
257     // newEthICOMinimum is the minimum amount of funds to raise
258     // newEthICOMaximum is the maximum amount of funds to raise
259     // silencePeriod is a number of blocks to wait after starting the ICO. No funds are accepted during the silence period. It can be set to zero.
260     // newEndBlock is the absolute block number at which the ICO must stop. It must be set after now + silence period.
261     function updateEthICOThresholds(uint256 _newWeiICOMinimum, uint256 _newWeiICOMaximum, uint256 _silencePeriod, uint256 _newEndBlock)
262     onlyStateControl
263     {
264         require(state == States.Initial || state == States.ValuationSet);
265         require(_newWeiICOMaximum > _newWeiICOMinimum);
266         require(block.number + silencePeriod < _newEndBlock);
267         require(block.number < _newEndBlock);
268         weiICOMinimum = _newWeiICOMinimum;
269         weiICOMaximum = _newWeiICOMaximum;
270         silencePeriod = _silencePeriod;
271         endBlock = _newEndBlock;
272         // initial conversion rate of ETH_HEROCOIN set now, this is used during the Ico phase.
273         ETH_HEROCOIN = ((totalSupply * percentForSale) / 100) / weiICOMaximum;
274         // check pointMultiplier
275         moveToState(States.ValuationSet);
276     }
277 
278     function startICO()
279     onlyStateControl
280     requireState(States.ValuationSet)
281     {
282         require(block.number < endBlock);
283         require(block.number + silencePeriod < endBlock);
284         startAcceptingFundsBlock = block.number + silencePeriod;
285         moveToState(States.Ico);
286     }
287 
288 
289     function endICO()
290     onlyStateControl
291     requireState(States.Ico)
292     {
293         if (this.balance < weiICOMinimum) {
294             moveToState(States.Underfunded);
295         }
296         else {
297             burnUnsoldCoins();
298             moveToState(States.Operational);
299         }
300     }
301 
302     function anyoneEndICO()
303     requireState(States.Ico)
304     {
305         require(block.number > endBlock);
306         if (this.balance < weiICOMinimum) {
307             moveToState(States.Underfunded);
308         }
309         else {
310             burnUnsoldCoins();
311             moveToState(States.Operational);
312         }
313     }
314 
315     function burnUnsoldCoins()
316     internal
317     {
318         uint256 soldcoins = this.balance * ETH_HEROCOIN;
319         totalSupply = soldcoins * 100 / percentForSale;
320         balances[initialHolder] = totalSupply - soldcoins;
321         //slashing the initial supply, so that the ico is selling 30% total
322     }
323 
324     function addToWhitelist(address _whitelisted)
325     onlyWhitelist
326         //    requireState(States.Ico)
327     {
328         whitelist[_whitelisted] = true;
329         Whitelisted(_whitelisted);
330     }
331 
332 
333     //emergency pause for the ICO
334     function pause()
335     onlyStateControl
336     requireState(States.Ico)
337     {
338         moveToState(States.Paused);
339     }
340 
341     //in case we want to completely abort
342     function abort()
343     onlyStateControl
344     requireState(States.Paused)
345     {
346         moveToState(States.Underfunded);
347     }
348 
349     //un-pause
350     function resumeICO()
351     onlyStateControl
352     requireState(States.Paused)
353     {
354         moveToState(States.Ico);
355     }
356 
357     //in case of a failed/aborted ICO every investor can get back their money
358     function requestRefund()
359     requireState(States.Underfunded)
360     {
361         require(balances[msg.sender] > 0);
362         //there is no need for updateAccount(msg.sender) since the token never became active.
363         uint256 payout = balances[msg.sender] / ETH_HEROCOIN;
364         //reverse calculate the amount to pay out
365         balances[msg.sender] = 0;
366         msg.sender.transfer(payout);
367     }
368 
369     //after the ico has run its course, the withdraw account can drain funds bit-by-bit as needed.
370     function requestPayout(uint _amount)
371     onlyWithdraw //very important!
372     requireState(States.Operational)
373     {
374         msg.sender.transfer(_amount);
375     }
376     /**
377     END ICO functions
378     */
379 
380     /**
381     BEGIN ERC20 functions
382     */
383     function transfer(address _to, uint256 _value)
384     requireState(States.Operational)
385     updateAccount(msg.sender) //update senders rake before transfer, so they can access their full balance
386     updateAccount(_to) //update receivers rake before transfer as well, to avoid over-attributing rake
387     enforceRake(msg.sender, _value)
388     returns (bool success) {
389         return super.transfer(_to, _value);
390     }
391 
392     function transferFrom(address _from, address _to, uint256 _value)
393     requireState(States.Operational)
394     updateAccount(_from) //update senders rake before transfer, so they can access their full balance
395     updateAccount(_to) //update receivers rake before transfer as well, to avoid over-attributing rake
396     enforceRake(_from, _value)
397     returns (bool success) {
398         return super.transferFrom(_from, _to, _value);
399     }
400 
401     function balanceOf(address _account)
402     constant
403     returns (uint256 balance) {
404         return balances[_account] + rakesOwing(_account);
405     }
406 
407     function payRake(uint256 _value)
408     requireState(States.Operational)
409     updateAccount(msg.sender)
410     returns (bool success) {
411         return payRakeInternal(msg.sender, _value);
412     }
413 
414 
415     function
416     payRakeInternal(address _sender, uint256 _value)
417     internal
418     returns (bool success) {
419 
420         if (balances[_sender] <= _value) {
421             return false;
422         }
423         if (_value != 0) {
424             Transfer(_sender, rakeEventPlaceholderAddress, _value);
425             balances[_sender] -= _value;
426             unclaimedRakes += _value;
427             //   calc amount of points from total:
428             uint256 pointsPaid = _value * pointMultiplier / totalSupply;
429             totalRakePoints += pointsPaid;
430         }
431         return true;
432 
433     }
434     /**
435     END ERC20 functions
436     */
437     /**
438     BEGIN Rake modifier updateAccount
439     */
440     modifier updateAccount(address _account) {
441         uint256 owing = rakesOwing(_account);
442         if (owing != 0) {
443             unclaimedRakes -= owing;
444             balances[_account] += owing;
445             Transfer(rakeEventPlaceholderAddress, _account, owing);
446         }
447         //also if 0 this needs to be called, since lastRakePoints need the right value
448         lastRakePoints[_account] = totalRakePoints;
449         _;
450     }
451 
452     //todo use safemath.sol
453     function rakesOwing(address _account)
454     internal
455     constant
456     returns (uint256) {//returns always > 0 value
457         //how much is _account owed, denominated in points from total supply
458         uint256 newRakePoints = totalRakePoints - lastRakePoints[_account];
459         //always positive
460         //weigh by my balance (dimension HC*10^18)
461         uint256 basicPoints = balances[_account] * newRakePoints;
462         //still positive
463         //normalize to dimension HC by moving comma left by 18 places
464         return (basicPoints) / pointMultiplier;
465     }
466     /**
467     END Rake modifier updateAccount
468     */
469 
470     // contest management functions
471 
472     modifier enforceRake(address _contest, uint256 _value){
473         //we calculate 1% of the total value, rounded up. division would round down otherwise.
474         //explicit brackets illustrate that the calculation only round down when dividing by 100, to avoid an expression
475         // like value * (99/100)
476         if (contests[_contest]) {
477             uint256 toPay = _value - ((_value * 99) / 100);
478             bool paid = payRakeInternal(_contest, toPay);
479             require(paid);
480         }
481         _;
482     }
483 
484     // all functions require HeroCoin operational state
485 
486 
487     // registerContest declares a contest to HeroCoin.
488     // It must be called from an address that has HeroCoin.
489     // This address is recorded as the contract admin.
490     function registerContest()
491     {
492         contests[msg.sender] = true;
493         ContestAnnouncement(msg.sender);
494     }
495 }
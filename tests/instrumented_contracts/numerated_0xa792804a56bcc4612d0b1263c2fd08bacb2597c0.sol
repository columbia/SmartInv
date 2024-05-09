1 pragma solidity ^0.4.23;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 
15 
16 
17 
18 /**
19  * @title ERC20 interface
20  * @dev see https://github.com/ethereum/EIPs/issues/20
21  */
22 contract ERC20 is ERC20Basic {
23 
24   function allowance(address owner, address spender)
25     public view returns (uint256);
26 
27   function transferFrom(address from, address to, uint256 value)
28     public returns (bool);
29 
30 
31   function approve(address spender, uint256 value) public returns (bool);
32   event Approval(
33     address indexed owner,
34     address indexed spender,
35     uint256 value
36   );
37 }
38 
39 
40 
41 
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that revert on error
46  */
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, reverts on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54     // benefit is lost if 'b' is also tested.
55     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
56     if (a == 0) {
57       return 0;
58     }
59 
60     uint256 c = a * b;
61     require(c / a == b);
62 
63     return c;
64   }
65 
66   /**
67   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
68   */
69   function div(uint256 a, uint256 b) internal pure returns (uint256) {
70     require(b > 0); // Solidity only automatically asserts when dividing by 0
71     uint256 c = a / b;
72     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73 
74     return c;
75   }
76 
77   /**
78   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
79   */
80   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81     require(b <= a);
82     uint256 c = a - b;
83 
84     return c;
85   }
86 
87   /**
88   * @dev Adds two numbers, reverts on overflow.
89   */
90   function add(uint256 a, uint256 b) internal pure returns (uint256) {
91     uint256 c = a + b;
92     require(c >= a);
93 
94     return c;
95   }
96 
97   /**
98   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
99   * reverts when dividing by zero.
100   */
101   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
102     require(b != 0);
103     return a % b;
104   }
105 }
106 
107 
108 /**
109  * @title Basic token
110  * @dev Basic version of StandardToken, with no allowances.
111  */
112 contract BasicToken is ERC20Basic {
113   using SafeMath for uint256;
114 
115   mapping(address => uint256) balances;
116 
117   uint256 totalSupply_;
118 
119   /**
120   * @dev Total number of tokens in existence
121   */
122   function totalSupply() public view returns (uint256) {
123     return totalSupply_;
124   }
125 
126 
127   /**
128   * @dev Gets the balance of the specified address.
129   * @param _owner The address to query the the balance of.
130   * @return An uint256 representing the amount owned by the passed address.
131   */
132   function balanceOf(address _owner) public view returns (uint256) {
133     return balances[_owner];
134   }
135 
136 }
137 
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * @dev https://github.com/ethereum/EIPs/issues/20
144  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  */
146 contract StandardToken is ERC20, BasicToken {
147 
148   mapping (address => mapping (address => uint256)) internal allowed;
149 
150   address master;
151 
152   bool public paused;
153 
154 
155   modifier isMaster {
156       require(msg.sender == master);
157       _;
158   }
159 
160   modifier isPause {
161    require(paused == true);
162    _;
163  }
164 
165   modifier isNotPause {
166    require(paused == false);
167    _;
168   }
169 
170 
171 
172 
173   /**
174    * @dev Function to check the amount of tokens that an owner allowed to a spender.
175    * @param _owner address The address which owns the funds.
176    * @param _spender address The address which will spend the funds.
177    * @return A uint256 specifying the amount of tokens still available for the spender.
178    */
179   function allowance(
180     address _owner,
181     address _spender
182    )
183     public
184     view
185     returns (uint256)
186   {
187     return allowed[_owner][_spender];
188   }
189 
190   /**
191    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
192    *
193    * Beware that changing an allowance with this method brings the risk that someone may use both the old
194    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
195    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
196    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197    * @param _spender The address which will spend the funds.
198    * @param _value The amount of tokens to be spent.
199    */
200   function approve(address _spender, uint256 _value) public isNotPause returns (bool) {
201     require(_spender != address(0));
202     require(balanceOf(msg.sender) >= _value);
203     require (balanceOf(_spender) + _value > balanceOf(_spender));
204     allowed[msg.sender][_spender] = _value;
205     emit Approval(msg.sender, _spender, _value);
206     return true;
207   }
208 
209   /**
210    * @dev Increase the amount of tokens that an owner allowed to a spender.
211    *
212    * approve should be called when allowed[_spender] == 0. To increment
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * @param _spender The address which will spend the funds.
217    * @param _addedValue The amount of tokens to increase the allowance by.
218    */
219   function increaseApproval(
220     address _spender,
221     uint _addedValue
222   )
223     public isNotPause
224     returns (bool)
225   {
226     require(_spender != address(0));
227     require(balanceOf(msg.sender) >= _addedValue);
228     require (allowed[msg.sender][_spender] + _addedValue > allowed[msg.sender][_spender]);
229     allowed[msg.sender][_spender] = (
230     allowed[msg.sender][_spender].add(_addedValue));
231     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232     return true;
233   }
234 
235   /**
236    * @dev Decrease the amount of tokens that an owner allowed to a spender.
237    *
238    * approve should be called when allowed[_spender] == 0. To decrement
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    * @param _spender The address which will spend the funds.
243    * @param _subtractedValue The amount of tokens to decrease the allowance by.
244    */
245   function decreaseApproval(
246     address _spender,
247     uint _subtractedValue
248   )
249     public isNotPause
250     returns (bool)
251   {
252     require(_spender != address(0));
253     uint oldValue = allowed[msg.sender][_spender];
254     if (_subtractedValue > oldValue) {
255       allowed[msg.sender][_spender] = 0;
256     } else {
257       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258     }
259     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263 }
264 
265 
266 contract NToken is StandardToken {
267 
268   string public constant name = "NToken";
269   string public constant symbol = "NT";
270   uint8 public constant decimals = 8;
271 
272   uint256 public constant INITIAL_SUPPLY = 660000000 * (10 ** uint256(decimals));
273   address coinbase;
274 
275   address private constant project_foundation_address     = 0x9F9bed103cCa9352C7a69A05f7b789a9fC32f5C7;
276   uint8   private constant project_foundation_percent     = 10;
277   uint256 private constant project_foundation_starttime   = 1558627200;
278   uint256 private constant project_foundation_interval    = 94608000;
279   uint256 private constant project_foundation_periods     = 1;
280 
281 
282 
283   address private constant community_reward_address       = 0x9F9bed103cCa9352C7a69A05f7b789a9fC32f5C7;
284   uint8   private constant community_reward_percent       = 90;
285 
286 
287 
288 
289 
290   struct Vesting {
291     uint256 startTime;
292     uint256 initReleaseAmount;
293     uint256 amount;
294     uint256 interval;
295     uint256 periods;
296     uint256 withdrawed;
297   }
298 
299   mapping (address => Vesting[]) vestings;
300 
301   event AssetLock(address indexed to,uint256 startTime,uint256 initReleaseAmount,uint256 amount,uint256 interval,uint256 periods);
302   /**
303   * @dev Constructor that gives msg.sender all of existing tokens.
304   */
305   constructor(address _master) public {
306    require(_master != address(0));
307    totalSupply_ = INITIAL_SUPPLY;
308    master = _master;
309    paused = false;
310    coinbase = _master;
311    balances[coinbase] = INITIAL_SUPPLY;
312 
313   
314    uint256 balance_project = INITIAL_SUPPLY * project_foundation_percent / 100;
315    assetLock(project_foundation_address,project_foundation_starttime,0,balance_project,project_foundation_interval,project_foundation_periods);
316 
317    uint256 balance_community_reward = INITIAL_SUPPLY * community_reward_percent / 100;
318    balances[community_reward_address] = balance_community_reward;
319    balances[coinbase] =  balances[coinbase].sub(balance_community_reward);
320 
321 
322  }
323 
324 
325   function assetLock(address _to,uint256 _startTime,uint256 _initReleaseAmount,uint256 _amount,uint256 _interval,uint256 _periods) internal {
326       require(balances[coinbase] >= _amount);
327       require(_initReleaseAmount <= _amount);
328       vestings[_to].push(Vesting(_startTime, _initReleaseAmount, _amount, _interval, _periods, 0));
329       balances[coinbase] = balances[coinbase].sub(_amount);
330       emit AssetLock(_to,_startTime,_initReleaseAmount,_amount,_interval,_periods);
331  }
332 
333   function batchTransfer(address[] _to, uint256[] _amount) public isNotPause returns (bool) {
334      for (uint i = 0; i < _to.length; i++) {
335        getVesting(msg.sender);
336        transfer(_to[i] , _amount[i]);
337      }
338      return true;
339    }
340 
341    /**
342    * @dev Transfer token for a specified address
343    * @param _to The address to transfer to.
344    * @param _value The amount to be transferred.
345    */
346    function transfer(address _to, uint256 _value) public isNotPause returns (bool) {
347      require(_to != address(0));
348      uint256 remain = availableBalance(msg.sender);
349      require(_value <= remain);
350      getVesting(msg.sender);
351      balances[msg.sender] = balances[msg.sender].sub(_value);
352      balances[_to] = balances[_to].add(_value);
353      emit Transfer(msg.sender, _to, _value);
354      return true;
355    }
356 
357 
358    /**
359     * @dev Transfer tokens from one address to another
360     * @param _from address The address which you want to send tokens from
361     * @param _to address The address which you want to transfer to
362     * @param _value uint256 the amount of tokens to be transferred
363     */
364    function transferFrom(
365      address _from,
366      address _to,
367      uint256 _value
368    )
369      public isNotPause
370      returns (bool)
371    {
372      require(_to != address(0));
373      require(_from != address(0));
374      require(_value <= allowed[_from][msg.sender]);
375      uint256 remain = availableBalance(_from);
376      require(_value <= remain);
377      getVesting(_from);
378      balances[_from] = balances[_from].sub(_value);
379      balances[_to] = balances[_to].add(_value);
380      allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
381      emit Transfer(_from, _to, _value);
382      return true;
383    }
384 
385 
386    function setPause() public isMaster isNotPause{
387      paused = true;
388    }
389 
390    function setResume() public isMaster isPause{
391      paused = false;
392    }
393 
394    function pauseStatus() public view isMaster returns (bool){
395      return paused;
396    }
397 
398 
399    function vestingBalance(address _owner) internal view returns (uint256) {
400      uint256 sum = 0;
401       for(uint i = 0 ;i < vestings[_owner].length;i++){
402         sum = sum.add(vestings[_owner][i].amount.sub(vestings[_owner][i].withdrawed));
403       }
404       return sum;
405    }
406 
407   /*
408   Current available balance
409   */
410    function availableBalance(address _owner) public view returns (uint256) {
411      uint256 sum = 0;
412       for(uint i = 0 ;i < vestings[_owner].length;i++){
413         Vesting memory vs = vestings[_owner][i];
414         uint256 release = vestingRelease(vs.startTime,vs.initReleaseAmount, vs.amount, vs.interval, vs.periods);
415         uint256 keep = release.sub(vs.withdrawed);
416         if(keep >= 0){
417           sum = sum.add(keep);
418         }
419       }
420       return sum.add(balances[_owner]);
421    }
422 
423    /*
424    Get all the assets of the user
425    */
426    function allBalance(address _owner)public view returns (uint256){
427      uint256 allbalance = vestingBalance(_owner);
428      return allbalance.add(balances[_owner]);
429    }
430     /*
431     Calculate the current time release
432     */
433    function vestingRelease(uint256 _startTime,uint256 _initReleaseAmount,uint256 _amount,uint256 _interval,uint256 _periods) public view returns (uint256) {
434     return vestingReleaseFunc(now,_startTime,_initReleaseAmount,_amount,_interval,_periods);
435    }
436 
437    /*
438    Calculate the current time release
439    */
440   function vestingReleaseFunc(uint256 _endTime,uint256 _startTime,uint256 _initReleaseAmount,uint256 _amount,uint256 _interval,uint256 _periods) public pure  returns (uint256) {
441     if (_endTime < _startTime) {
442       return 0;
443     }
444     uint256 last = _endTime.sub(_startTime);
445     uint256 allTime =  _periods.mul(_interval);
446     if (last >= allTime) {
447       return _amount;
448     }
449     uint256 eachPeriodAmount = _amount.sub(_initReleaseAmount).div(_periods);
450     uint256 lastTime = last.div(_interval);
451     uint256 vestingAmount = eachPeriodAmount.mul(lastTime).add(_initReleaseAmount);
452     return vestingAmount;
453   }
454 
455 
456 
457    /*
458    Get vesting funds
459    */
460    function getVesting(address _to) internal {
461      uint256 sum = 0;
462      for(uint i=0;i< vestings[_to].length;i++){
463        if(vestings[_to][i].amount == vestings[_to][i].withdrawed){
464          continue;
465        }else{
466          Vesting  memory vs = vestings[_to][i];
467          uint256 release = vestingRelease(vs.startTime,vs.initReleaseAmount, vs.amount, vs.interval, vs.periods);
468          uint256 keep = release.sub(vs.withdrawed);
469          if(keep >= 0){
470            vestings[_to][i].withdrawed = release;
471            sum = sum.add(keep);
472          }
473        }
474      }
475      if(sum > 0 ){
476        balances[_to] = balances[_to].add(sum);
477      }
478    }
479 
480    /**
481    * @dev Gets the balance of the specified address.
482    * @param _owner The address to query the the balance of.
483    * @return An uint256 representing the amount owned by the passed address.
484    */
485    function balanceOf(address _owner) public view returns (uint256) {
486      return availableBalance(_owner);
487    }
488 }
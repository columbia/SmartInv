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
202     allowed[msg.sender][_spender] = _value;
203     emit Approval(msg.sender, _spender, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    *
210    * approve should be called when allowed[_spender] == 0. To increment
211    * allowed value is better to use this function to avoid 2 calls (and wait until
212    * the first transaction is mined)
213    * From MonolithDAO Token.sol
214    * @param _spender The address which will spend the funds.
215    * @param _addedValue The amount of tokens to increase the allowance by.
216    */
217   function increaseApproval(
218     address _spender,
219     uint _addedValue
220   )
221     public isNotPause
222     returns (bool)
223   {
224     require(_spender != address(0));
225     allowed[msg.sender][_spender] = (
226       allowed[msg.sender][_spender].add(_addedValue));
227     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231   /**
232    * @dev Decrease the amount of tokens that an owner allowed to a spender.
233    *
234    * approve should be called when allowed[_spender] == 0. To decrement
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _subtractedValue The amount of tokens to decrease the allowance by.
240    */
241   function decreaseApproval(
242     address _spender,
243     uint _subtractedValue
244   )
245     public isNotPause
246     returns (bool)
247   {
248     require(_spender != address(0));
249     uint oldValue = allowed[msg.sender][_spender];
250     if (_subtractedValue > oldValue) {
251       allowed[msg.sender][_spender] = 0;
252     } else {
253       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
254     }
255     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259 }
260 
261 
262 contract KocToken is StandardToken {
263 
264   string public constant name = "King Of Catering (Entertainment) ";
265   string public constant symbol = "KOC";
266   uint8 public constant decimals = 18;
267 
268   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
269   address coinbase;
270 
271   address private constant project_foundation_address     = 0x5715f21002de7ac8097593290591907c459295c5;
272   uint8   private constant project_foundation_percent     = 10;
273   uint256 private constant project_foundation_starttime   = 1604160000;
274   uint256 private constant project_foundation_interval    = 2592000;
275   uint256 private constant project_foundation_periods     = 20;
276 
277   address private constant technical_team_address         = 0x3ad3106970609844652205a4a8fc68e6aa590eb1;
278   uint8   private constant technical_team_percent         = 10;
279   uint256 private constant technical_team_starttime       = 1635696000;
280   uint256 private constant technical_team_interval        = 2592000;
281   uint256 private constant technical_team_periods         = 20;
282 
283   address private constant community_reward_address       = 0x1a35941a5a52f0d212b67b87af51daa23a9fb7fc;
284   uint8   private constant community_reward_percent       = 30;
285 
286   address private constant community_operation_address    = 0x334eb99a16bb1bd5a8ecc6c2ce44fb270f4bf451;
287   uint8   private constant community_operation_percent    = 30;
288 
289   address private constant user_mining_address            = 0x939302d1eab4009d7cee5d410a4f61a5f2864d7a;
290   uint8   private constant user_mining_percent            = 10;
291 
292   address private constant cornerstone_wheel_address      = 0xbe45decacf12248f4459f5e0295de12993b34b15;
293   uint8   private constant cornerstone_wheel_percent      = 5;
294 
295   address private constant private_wheel_address          = 0xf35da84e81432c86e9254206c12cf6d4a6221384;
296   uint8   private constant private_wheel_percent          = 5;
297 
298 
299 
300   struct Vesting {
301     uint256 startTime;
302     uint256 initReleaseAmount;
303     uint256 amount;
304     uint256 interval;
305     uint256 periods;
306     uint256 withdrawed;
307   }
308 
309   mapping (address => Vesting[]) vestings;
310 
311   event AssetLock(address indexed to,uint256 startTime,uint256 initReleaseAmount,uint256 amount,uint256 interval,uint256 periods);
312   /**
313   * @dev Constructor that gives msg.sender all of existing tokens.
314   */
315   constructor(address _master) public {
316    require(_master != address(0));
317    totalSupply_ = INITIAL_SUPPLY;
318    master = _master;
319    paused = false;
320    coinbase = msg.sender;
321    balances[coinbase] = INITIAL_SUPPLY;
322 
323    uint256 balance_technical = INITIAL_SUPPLY * technical_team_percent / 100;
324    assetLock(technical_team_address,technical_team_starttime,0,balance_technical,technical_team_interval,technical_team_periods);
325 
326    uint256 balance_project = INITIAL_SUPPLY * project_foundation_percent / 100;
327    assetLock(project_foundation_address,project_foundation_starttime,0,balance_project,project_foundation_interval,project_foundation_periods);
328 
329    uint256 balance_community_reward = INITIAL_SUPPLY * community_reward_percent / 100;
330    balances[community_reward_address] = balance_community_reward;
331    balances[coinbase] =  balances[coinbase].sub(balance_community_reward);
332 
333    uint256 balance_community_operation = INITIAL_SUPPLY * community_operation_percent / 100;
334    balances[community_operation_address] = balance_community_operation;
335    balances[coinbase] =  balances[coinbase].sub(balance_community_operation);
336 
337    uint256 balance_user_mining = INITIAL_SUPPLY * user_mining_percent / 100;
338    balances[user_mining_address] = balance_user_mining;
339    balances[coinbase] =  balances[coinbase].sub(balance_user_mining);
340 
341    uint256 balance_cornerstone_wheel = INITIAL_SUPPLY * cornerstone_wheel_percent / 100;
342    balances[cornerstone_wheel_address] = balance_cornerstone_wheel;
343    balances[coinbase] =  balances[coinbase].sub(balance_cornerstone_wheel);
344 
345    uint256 balance_private_wheel = INITIAL_SUPPLY * private_wheel_percent / 100;
346    balances[private_wheel_address] = balance_private_wheel;
347    balances[coinbase] =  balances[coinbase].sub(balance_private_wheel);
348 
349 
350  }
351 
352 
353   function assetLock(address _to,uint256 _startTime,uint256 _initReleaseAmount,uint256 _amount,uint256 _interval,uint256 _periods) internal {
354       require(balances[coinbase] >= _amount);
355       require(_initReleaseAmount <= _amount);
356       vestings[_to].push(Vesting(_startTime, _initReleaseAmount, _amount, _interval, _periods, 0));
357       balances[coinbase] = balances[coinbase].sub(_amount);
358       emit AssetLock(_to,_startTime,_initReleaseAmount,_amount,_interval,_periods);
359  }
360 
361   function batchTransfer(address[] _to, uint256[] _amount) public isNotPause returns (bool) {
362      for (uint i = 0; i < _to.length; i++) {
363        getVesting(msg.sender);
364        transfer(_to[i] , _amount[i]);
365      }
366      return true;
367    }
368 
369    /**
370    * @dev Transfer token for a specified address
371    * @param _to The address to transfer to.
372    * @param _value The amount to be transferred.
373    */
374    function transfer(address _to, uint256 _value) public isNotPause returns (bool) {
375      require(_to != address(0));
376      uint256 remain = availableBalance(msg.sender);
377      require(_value <= remain);
378      getVesting(msg.sender);
379      balances[msg.sender] = balances[msg.sender].sub(_value);
380      balances[_to] = balances[_to].add(_value);
381      emit Transfer(msg.sender, _to, _value);
382      return true;
383    }
384 
385 
386    /**
387     * @dev Transfer tokens from one address to another
388     * @param _from address The address which you want to send tokens from
389     * @param _to address The address which you want to transfer to
390     * @param _value uint256 the amount of tokens to be transferred
391     */
392    function transferFrom(
393      address _from,
394      address _to,
395      uint256 _value
396    )
397      public isNotPause
398      returns (bool)
399    {
400      require(_to != address(0));
401      require(_from != address(0));
402      require(_value <= allowed[_from][msg.sender]);
403      uint256 remain = availableBalance(_from);
404      require(_value <= remain);
405      getVesting(_from);
406      balances[_from] = balances[_from].sub(_value);
407      balances[_to] = balances[_to].add(_value);
408      allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
409      emit Transfer(_from, _to, _value);
410      return true;
411    }
412 
413 
414    function setPause() public isMaster isNotPause{
415      paused = true;
416    }
417 
418    function setResume() public isMaster isPause{
419      paused = false;
420    }
421 
422    function pauseStatus() public view isMaster returns (bool){
423      return paused;
424    }
425 
426 
427    function vestingBalance(address _owner) internal view returns (uint256) {
428      uint256 sum = 0;
429       for(uint i = 0 ;i < vestings[_owner].length;i++){
430         sum = sum.add(vestings[_owner][i].amount.sub(vestings[_owner][i].withdrawed));
431       }
432       return sum;
433    }
434 
435   /*
436   Current available balance
437   */
438    function availableBalance(address _owner) public view returns (uint256) {
439      uint256 sum = 0;
440       for(uint i = 0 ;i < vestings[_owner].length;i++){
441         Vesting memory vs = vestings[_owner][i];
442         uint256 release = vestingRelease(vs.startTime,vs.initReleaseAmount, vs.amount, vs.interval, vs.periods);
443         uint256 keep = release.sub(vs.withdrawed);
444         if(keep >= 0){
445           sum = sum.add(keep);
446         }
447       }
448       return sum.add(balances[_owner]);
449    }
450 
451    /*
452    Get all the assets of the user
453    */
454    function allBalance(address _owner)public view returns (uint256){
455      uint256 allbalance = vestingBalance(_owner);
456      return allbalance.add(balances[_owner]);
457    }
458     /*
459     Calculate the current time release
460     */
461    function vestingRelease(uint256 _startTime,uint256 _initReleaseAmount,uint256 _amount,uint256 _interval,uint256 _periods) public view returns (uint256) {
462     return vestingReleaseFunc(now,_startTime,_initReleaseAmount,_amount,_interval,_periods);
463    }
464 
465    /*
466    Calculate the current time release
467    */
468   function vestingReleaseFunc(uint256 _endTime,uint256 _startTime,uint256 _initReleaseAmount,uint256 _amount,uint256 _interval,uint256 _periods) public pure  returns (uint256) {
469     if (_endTime < _startTime) {
470       return 0;
471     }
472     uint256 last = _endTime.sub(_startTime);
473     uint256 allTime =  _periods.mul(_interval);
474     if (last >= allTime) {
475       return _amount;
476     }
477     uint256 eachPeriodAmount = _amount.sub(_initReleaseAmount).div(_periods);
478     uint256 lastTime = last.div(_interval);
479     uint256 vestingAmount = eachPeriodAmount.mul(lastTime).add(_initReleaseAmount);
480     return vestingAmount;
481   }
482 
483 
484 
485    /*
486    Get vesting funds
487    */
488    function getVesting(address _to) internal {
489      uint256 sum = 0;
490      for(uint i=0;i< vestings[_to].length;i++){
491        if(vestings[_to][i].amount == vestings[_to][i].withdrawed){
492          continue;
493        }else{
494          Vesting  memory vs = vestings[_to][i];
495          uint256 release = vestingRelease(vs.startTime,vs.initReleaseAmount, vs.amount, vs.interval, vs.periods);
496          uint256 keep = release.sub(vs.withdrawed);
497          if(keep >= 0){
498            vestings[_to][i].withdrawed = release;
499            sum = sum.add(keep);
500          }
501        }
502      }
503      if(sum > 0 ){
504        balances[_to] = balances[_to].add(sum);
505      }
506    }
507 
508    /**
509    * @dev Gets the balance of the specified address.
510    * @param _owner The address to query the the balance of.
511    * @return An uint256 representing the amount owned by the passed address.
512    */
513    function balanceOf(address _owner) public view returns (uint256) {
514      return availableBalance(_owner);
515    }
516 }
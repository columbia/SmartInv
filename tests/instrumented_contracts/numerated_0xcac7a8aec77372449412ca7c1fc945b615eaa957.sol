1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.4.21 <0.7.0;
3 pragma experimental ABIEncoderV2;
4 
5 
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12     if (a == 0) {
13       return 0;
14     }
15     c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     // uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return a / b;
28   }
29 
30   /**
31   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42     c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 //...................................................................................
48 
49 abstract contract ERC20Basic {
50   function totalSupply() public virtual view returns (uint256);
51   function balanceOf(address who) public virtual view returns (uint256);
52   function transfer(address to, uint256 value) public virtual returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 
57 //..............................................................................................
58 
59 abstract contract ERC20 is ERC20Basic {
60   function allowance(address owner, address spender) public virtual view returns (uint256);
61   function transferFrom(address from, address to, uint256 value) public virtual returns (bool);
62   function approve(address spender, uint256 value) public virtual returns (bool);
63   event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 //..................................................................................................
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   uint256 totalSupply_;
73 
74   /**
75   * @dev total number of tokens in existence
76   */
77   function totalSupply() public override view returns (uint256) {
78     return totalSupply_;
79   }
80    
81   /**
82   * @dev transfer token for a specified address
83   * @param _to The address to transfer to.
84   * @param _value The amount to be transferred.
85   */
86   function transfer(address _to, uint256 _value) public override returns (bool) {
87     require(_to != address(0));
88     require(_value <= balances[msg.sender]);
89 
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     emit Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public  override view returns (uint256) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 //........................................................................................
108 
109 contract StandardToken is ERC20, BasicToken {
110 
111   mapping (address => mapping (address => uint256)) internal allowed;
112 
113   /**
114    * @dev Transfer tokens from one address to another
115    * @param _from address The address which you want to send tokens from
116    * @param _to address The address which you want to transfer to
117    * @param _value uint256 the amount of tokens to be transferred
118    */
119   function transferFrom(address _from, address _to, uint256 _value) public override returns (bool) {
120     require(_to != address(0));
121     require(_value <= balances[_from]);
122     require(_value <= allowed[_from][msg.sender]);
123 
124     balances[_from] = balances[_from].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127     emit Transfer(_from, _to, _value);
128     return true;
129   }
130 
131   /**
132    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
133    *
134    * Beware that changing an allowance with this method brings the risk that someone may use both the old
135    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
136    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
137    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138    * @param _spender The address which will spend the funds.
139    * @param _value The amount of tokens to be spent.
140    */
141   function approve(address _spender, uint256 _value) public override returns (bool) {
142     allowed[msg.sender][_spender] = _value;
143     emit Approval(msg.sender, _spender, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Function to check the amount of tokens that an owner allowed to a spender.
149    * @param _owner address The address which owns the funds.
150    * @param _spender address The address which will spend the funds.
151    * @return A uint256 specifying the amount of tokens still available for the spender.
152    */
153   function allowance(address _owner, address _spender) public override view returns (uint256) {
154     return allowed[_owner][_spender];
155   }
156 
157   /**
158    * @dev Increase the amount of tokens that an owner allowed to a spender.
159    *
160    * approve should be called when allowed[_spender] == 0. To increment
161    * allowed value is better to use this function to avoid 2 calls (and wait until
162    * the first transaction is mined)
163    * From MonolithDAO Token.sol
164    * @param _spender The address which will spend the funds.
165    * @param _addedValue The amount of tokens to increase the allowance by.
166    */
167   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
168     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
169     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173   /**
174    * @dev Decrease the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To decrement
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _subtractedValue The amount of tokens to decrease the allowance by.
182    */
183   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
184     uint oldValue = allowed[msg.sender][_spender];
185     if (_subtractedValue > oldValue) {
186       allowed[msg.sender][_spender] = 0;
187     } else {
188       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
189     }
190     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 
194 }
195 //....................................................................................
196 
197 contract YexToken is StandardToken {
198   address public administrator;
199   string public constant name = "Yolex.io";
200   string public constant symbol = "YEX";
201   uint public constant decimals = 18;
202   uint256 public constant INITIAL_SUPPLY = 100 * (10 ** decimals);
203 
204 
205    modifier onlyAdminstrator(){
206      require(administrator == msg.sender, "requires admin priviledge");
207      _;
208    }
209 
210 }
211 
212 
213 contract TokenStakingReward is YexToken {
214    address public yolexController;
215    mapping(string => RewardPackage) public rewardPackages;
216    MintedTokensRecord[] public tokenMintsRecord;
217    mapping(address => Staker) public stackers;
218    RewardPackage[] public listOfPackages;
219    uint public salePrice = 5 ether;
220    uint public presaleCount = 0;
221    string prePackage = "PRESALE";
222    
223    
224    constructor() public {
225     totalSupply_ = INITIAL_SUPPLY;
226     administrator = msg.sender;
227     balances[administrator] = INITIAL_SUPPLY;
228   }
229    
230    
231 
232    modifier onlyController(){
233      require(
234      administrator == msg.sender || 
235      yolexController == msg.sender,
236      "requires controller or admin priviledge");
237      _;
238    }
239   
240 
241    event AdminChange (
242        string indexed message,
243        address indexed newAdminAddress
244    );
245    
246    
247    struct MintedTokensRecord {
248       uint amount;
249       uint timeStamp;
250    }
251 
252    struct RewardPackage {
253       uint id;
254       string symbol;
255       string packageName;
256       string rebasePercent;
257       string rewardPercent;
258       uint256 durationInDays;
259       uint256 rewardCapPercent;
260       bool isActive;
261    }
262 
263 
264    struct Staker {
265       uint id;
266       address stakerAddress;
267       uint256 amountStaked;
268       bool isActive;
269       bool isMatured;
270       uint256 startDate;
271       uint256 endDate;
272       string stakingPackage;
273       uint256 rewards;
274       uint256 rewardCap;
275       string rewardPercent;
276       uint256 rewardCapPercent;
277    }
278 
279    struct Rewards {
280       address stakerAddress;
281       uint256 reward;
282       bool isMatured;
283    }
284    
285    address newAdminAddress;
286    address newControllerAddress;
287    
288    function changeRate(uint _newRate) external onlyAdminstrator returns(bool){
289        salePrice = _newRate;
290        return true;
291    }
292 
293  
294    function assignNewAdministrator(address _newAdminAddress) external onlyAdminstrator {
295      newAdminAddress = _newAdminAddress;
296      emit AdminChange("confirming new Adminstrator address", newAdminAddress);
297    }
298 
299 
300    function acceptAdminRights() external {
301      require(msg.sender == newAdminAddress, "new admistrator address mismatch");
302      uint256 _value = balances[administrator];
303      balances[administrator] = balances[administrator].sub(_value);
304      balances[newAdminAddress] = balances[newAdminAddress].add(_value);
305      administrator = newAdminAddress;
306      emit AdminChange("New Adminstrator address", administrator);
307    }
308 
309 
310    function assignNewController(address _newControllerAddress) external onlyAdminstrator {
311      newControllerAddress = _newControllerAddress;
312      emit AdminChange("confirming new controller address", newControllerAddress);
313    }
314 
315 
316    function acceptControllerRights() external {
317      require(msg.sender == newControllerAddress, "new controller address mismatch");
318      yolexController = newControllerAddress;
319      emit AdminChange("New controller address", yolexController);
320    }
321 
322    function presale() external payable {
323        require(msg.value >= salePrice, "sent eth too small");
324        require(presaleCount < 45, "presale closed.");
325        uint _amount = msg.value.div(salePrice);
326        uint _amountToken = _amount.mul(10 ** decimals);
327        balances[administrator] = balances[administrator].sub(_amountToken);
328        balances[msg.sender] = balances[msg.sender].add(_amountToken);
329        presaleCount = presaleCount.add(_amount);
330        createStaking(_amountToken, prePackage);
331    }
332 
333    uint stakingID;
334    uint packageID;
335    function createStaking(uint256 _amount,
336      string memory _packageSymbol
337    )
338    public returns(Staker memory) {
339        RewardPackage memory _package = rewardPackages[_packageSymbol];
340        require(_amount <= balances[msg.sender], "insuffient funds");
341        require(!stackers[msg.sender].isActive, "You already have an active stake");
342        require(_package.isActive, "You can only stake on a active reward package");
343        uint256 _rewardCap = _amount.mul(_package.rewardCapPercent).div(100);
344        uint256 _endDate = numberDaysToTimestamp(_package.durationInDays);
345        transfer(address(this), _amount);
346        Staker memory _staker = Staker(stakingID, msg.sender, _amount, true, false, now, _endDate, _packageSymbol, 0, _rewardCap, _package.rewardPercent, _package.rewardCapPercent);
347        stakingID++;
348        stackers[msg.sender] = _staker;
349        return _staker;
350    }
351    
352 
353    function unstake() external returns(bool success){
354      Staker memory _staker = stackers[msg.sender];
355      require(_staker.endDate <= now, "cannot unstake yet");
356      require(_staker.isMatured, "reward is not matured for withdrawal");
357      require(_staker.isActive, "staking should still be active");
358      uint256 _amount = _staker.amountStaked;
359      balances[address(this)] = balances[address(this)].sub(_amount);
360      uint256 totalRewards = _amount.add(_staker.rewards);
361      balances[msg.sender] = balances[msg.sender].add(totalRewards);
362      stackers[msg.sender].isActive = false;
363      mintTokens(_staker.rewards);
364      emit Transfer(address(this), msg.sender, totalRewards);
365      return true;
366    }
367  
368  
369 
370    function distributeStakingRewards(Rewards[] calldata _rewards) external onlyController returns(bool){
371       for (uint index = 0; index < _rewards.length; index++) {
372           uint totalRewards = stackers[_rewards[index].stakerAddress].rewards.add(_rewards[index].reward);
373           if (stackers[_rewards[index].stakerAddress].isActive == true &&
374                totalRewards <= stackers[_rewards[index].stakerAddress].rewardCap) {
375                stackers[_rewards[index].stakerAddress].rewards = totalRewards;
376                if(_rewards[index].isMatured){
377                    indicateMaturity(_rewards[index].stakerAddress, _rewards[index].isMatured);
378                }
379           }
380       }
381       return true;
382    }
383     
384  
385     function indicateMaturity(address _accountAddress, bool status) internal  returns(bool success) {
386        require(_accountAddress != address(0), "the stacker address is needed");
387        stackers[_accountAddress].isMatured = status;
388        return true;
389     }
390     
391 
392 
393    function createPackage(
394      string memory _packageName,
395      string memory _symbol,
396      string memory _rebasePercent,
397      string memory _rewardPercent,
398      uint256 _rewardCapPercent,
399      uint256 _durationInDays
400      )
401    public onlyController returns(RewardPackage memory) {
402        numberDaysToTimestamp(_durationInDays);
403        RewardPackage memory _package = RewardPackage(
404          packageID,
405          _symbol,
406          _packageName,
407          _rebasePercent,
408          _rewardPercent,
409          _durationInDays,
410          _rewardCapPercent,
411          true
412          );
413          if (rewardPackages[_symbol].isActive) {
414              revert("package symbol should be unique");
415             } else {
416               packageID++;
417               rewardPackages[_symbol] = _package;
418               listOfPackages.push(_package);
419               return _package;
420           }
421    }
422    
423 
424    function numberDaysToTimestamp (uint _numberOfDays) private view returns(uint256 time){
425         if (_numberOfDays == 3) {
426              return now + 4 days;
427         } else if(_numberOfDays == 7){
428             return now.add(8 days);
429         }else if(_numberOfDays == 30){
430             return now.add(31 days);
431         }else if(_numberOfDays == 60){
432             return now.add(61 days);
433         }else if(_numberOfDays == 90){
434             return now.add(91 days);
435         }else if(_numberOfDays == 180){
436             return now.add(181 days);
437         }
438         else {
439           revert("The number of days should be either 3, 7, 30, 60 90, or 180 days");
440         }
441     }
442    
443 
444     function increaseStakingAmount(uint _amount) external returns(bool success){
445        require(stackers[msg.sender].isActive, "should have an active stake");
446        transfer(address(this), _amount);
447        stackers[msg.sender].amountStaked = stackers[msg.sender].amountStaked.add(_amount);
448        uint256 _amountStaked = stackers[msg.sender].amountStaked;
449        uint256 _rewardCap = _amountStaked.mul(stackers[msg.sender].rewardCapPercent).div(100);
450        stackers[msg.sender].rewardCap = _rewardCap;
451        return true;
452     }
453 
454 
455     function deactivatePackage(string calldata _symbol) external onlyController returns(RewardPackage memory){
456        bytes memory strToByte = bytes(_symbol);
457        require(strToByte.length > 1, "The package symbol should be specified");
458        rewardPackages[_symbol].isActive = false;
459        listOfPackages[rewardPackages[_symbol].id].isActive = false;
460        return rewardPackages[_symbol];
461     }
462     
463     function mintTokens(uint256 _amount) private returns(bool, uint) { 
464         totalSupply_ = totalSupply_.add(_amount);
465         tokenMintsRecord.push(MintedTokensRecord(_amount, now));
466         return(true, totalSupply_);
467     }
468     
469     function updatePrePackage(string calldata _packageSymbol) external onlyAdminstrator {
470         prePackage = _packageSymbol;
471     }
472     
473     function transferToWallet(uint _amount, address payable _receipient) external onlyAdminstrator returns(bool){
474         _receipient.transfer(_amount);
475         return true;
476      }
477     
478     receive() payable external {}
479 }
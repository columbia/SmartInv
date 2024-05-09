1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract ApproveAndCallReceiver {
30     function receiveApproval(address _from, uint256 _amount, address _token, bytes _data) public;
31 }
32 
33 contract Controlled {
34     modifier onlyController { 
35         require(msg.sender == controller); 
36         _; 
37     }
38 
39     address public controller;
40 
41     constructor() public {
42       controller = msg.sender;
43     }
44 
45     function changeController(address _newController) onlyController public {
46         controller = _newController;
47     }
48 }
49 
50 contract TokenAbout is Controlled {
51     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
52 
53     function isContract(address _addr) constant internal returns (bool) {
54         if (_addr == 0) {
55             return false;
56         }
57         uint256 size;
58         assembly {
59             size := extcodesize(_addr)
60         }
61         return (size > 0);
62     }
63 
64     function claimTokens(address[] tokens) onlyController public {
65         require(tokens.length <= 100, "tokens.length too long");
66         address _token;
67         uint256 balance;
68         ERC20Token token;
69         for(uint256 i; i<tokens.length; i++){
70             _token = tokens[i];
71             if (_token == 0x0) {
72                 balance = address(this).balance;
73                 if(balance > 0){
74                     msg.sender.transfer(balance);
75                 }
76             }else{
77                 token = ERC20Token(_token);
78                 balance = token.balanceOf(address(this));
79                 token.transfer(msg.sender, balance);
80                 emit ClaimedTokens(_token, msg.sender, balance);
81             }
82         }
83     }
84 }
85 
86 contract TokenController {
87     function proxyPayment(address _owner) payable public returns(bool);
88     function onTransfer(address _from, address _to, uint _amount) public view returns(bool);
89     function onApprove(address _owner, address _spender, uint _amount) public view returns(bool);
90 }
91 
92 contract ERC20Token {
93     uint256 public totalSupply;
94     mapping (address => uint256) public balanceOf;
95     function transfer(address _to, uint256 _value) public returns (bool success);
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
97     function approve(address _spender, uint256 _value) public returns (bool success);
98     mapping (address => mapping (address => uint256)) public allowance;
99 
100     event Transfer(address indexed _from, address indexed _to, uint256 _value);
101     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
102 }
103 
104 contract TokenI is ERC20Token, Controlled {
105     string public name;                //The Token's name: e.g. DigixDAO Tokens
106     uint8 public decimals = 18;             //Number of decimals of the smallest unit
107     string public symbol;              //An identifier: e.g. REP
108     function approveAndCall( address _spender, uint256 _amount, bytes _extraData) public returns (bool success);
109     function generateTokens(address _owner, uint _amount) public returns (bool);
110     function destroyTokens(address _owner, uint _amount) public returns (bool);
111     function enableTransfers(bool _transfersEnabled) public;
112 }
113 
114 contract Token is TokenI, TokenAbout {
115     using SafeMath for uint256;
116     address public owner;
117     string public techProvider = "WeYii Tech(https://weyii.co)";
118 
119     mapping (uint8 => uint256[]) public freezeOf; //所有数额，地址与数额合并为uint256，位运算拆分。
120     uint8  currUnlockStep; //当前解锁step
121     uint256 currUnlockSeq; //当前解锁step 内的游标
122 
123     mapping (uint8 => bool) public stepUnlockInfo; //所有锁仓，key 使用序号向上增加，value,是否已解锁。
124     mapping (address => uint256) public freezeOfUser; //用户所有锁仓，方便用户查询自己锁仓余额
125     mapping (uint8 => uint256) public stepLockend; //key:锁仓step，value：解锁时
126 
127     bool public transfersEnabled = true;
128 
129     event Burn(address indexed from, uint256 value);
130     event Freeze(address indexed from, uint256 value);
131     event Unfreeze(address indexed from, uint256 value);
132 
133     constructor(uint256 initialSupply, string tokenName, string tokenSymbol, address initialOwner) public {
134         name = tokenName;
135         symbol = tokenSymbol;
136         owner = initialOwner;
137         totalSupply = initialSupply*uint256(10)**decimals;
138         balanceOf[owner] = totalSupply;
139     }
140 
141     modifier onlyOwner() {
142         require(msg.sender == owner);
143         _;
144     }
145 
146     modifier ownerOrController(){
147         require(msg.sender == owner || msg.sender == controller);
148         _;
149     }
150 
151     modifier transable(){
152         require(transfersEnabled);
153         _;
154     }
155 
156     modifier ownerOrUser(address user){
157         require(msg.sender == owner || msg.sender == user);
158         _;
159     }
160 
161     modifier userOrController(address user){
162         require(msg.sender == user || msg.sender == owner || msg.sender == controller);
163         _;
164     }
165 
166     modifier realUser(address user){
167         require(user != 0x0);
168         _;
169     }
170 
171     modifier moreThanZero(uint256 _value){
172         require(_value > 0);
173         _;
174     }
175 
176     modifier userEnough(address _user, uint256 _amount) {
177         require(balanceOf[_user] >= _amount);
178         _;
179     }
180 
181     function addLockStep(uint8 _step, uint _endTime) onlyController external returns(bool) {
182         stepLockend[_step] = _endTime;
183     }
184 
185     function transfer(address _to, uint256 _value) realUser(_to) moreThanZero(_value) transable public returns (bool) {
186         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);                     // Subtract from the sender
187         balanceOf[_to] = balanceOf[_to].add(_value);                            // Add the same to the recipient
188         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
189         return true;
190     }
191 
192     function approve(address _spender, uint256 _value) transable public returns (bool success) {
193         require(_value == 0 || (allowance[msg.sender][_spender] == 0));
194         allowance[msg.sender][_spender] = _value;
195         emit Approval(msg.sender, _spender, _value);
196         return true;
197     }
198 
199     function unApprove(address _spender, uint256 _value) moreThanZero(_value) transable public returns (bool success) {
200         require(_value == 0 || (allowance[msg.sender][_spender] == 0));
201         allowance[msg.sender][_spender] = allowance[msg.sender][_spender].sub(_value);
202         emit Approval(msg.sender, _spender, _value);
203         return true;
204     }
205 
206     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) transable public returns (bool success) {
207         require(approve(_spender, _amount));
208         ApproveAndCallReceiver(_spender).receiveApproval(msg.sender, _amount, this, _extraData);
209         return true;
210     }
211 
212     function transferFrom(address _from, address _to, uint256 _value) realUser(_from) realUser(_to) moreThanZero(_value) transable public returns (bool success) {
213         require(balanceOf[_from] >= _value);                // Check if the sender has enough
214         require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
215         require(_value <= allowance[_from][msg.sender]);    // Check allowance
216         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
217         balanceOf[_to] = balanceOf[_to].add(_value);                             // Add the same to the recipient
218         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
219         emit Transfer(_from, _to, _value);
220         return true;
221     }
222     
223     function transferMulti(address[] _to, uint256[] _value) transable public returns (bool success, uint256 amount){
224         require(_to.length == _value.length && _to.length <= 300, "transfer once should be less than 300, or will be slow");
225         uint256 balanceOfSender = balanceOf[msg.sender];
226         uint256 len = _to.length;
227         for(uint256 j; j<len; j++){
228             require(_value[j] <= balanceOfSender); //limit transfer value
229             amount = amount.add(_value[j]);
230         }
231         require(balanceOfSender > amount ); //check enough and not overflow
232         balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount);
233         address _toI;
234         uint256 _valueI;
235         for(uint256 i; i<len; i++){
236             _toI = _to[i];
237             _valueI = _value[i];
238             balanceOf[_toI] = balanceOf[_toI].add(_valueI);
239             emit Transfer(msg.sender, _toI, _valueI);
240         }
241         return (true, amount);
242     }
243     
244     function transferMultiSameValue(address[] _to, uint256 _value) transable public returns (bool){
245         require(_to.length <= 300, "transfer once should be less than 300, or will be slow");
246         uint256 len = _to.length;
247         uint256 amount = _value.mul(len);
248         balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount);
249         address _toI;
250         for(uint256 i; i<len; i++){
251             _toI = _to[i];
252             balanceOf[_toI] = balanceOf[_toI].add(_value);
253             emit Transfer(msg.sender, _toI, _value);
254         }
255         return true;
256     }
257 
258     function freeze(address _user, uint256[] _value, uint8[] _step) onlyController public returns (bool success) {
259         require(_value.length == _step.length, "length of value and step must be equal");
260         require(_value.length <= 100, "lock step should less or equal than 100");
261         uint256 amount; //冻结总额
262         for(uint i; i<_value.length; i++){
263             amount = amount.add(_value[i]);
264         }
265         require(balanceOf[_user] >= amount, "balance of user must bigger or equal than amount of all steps");
266         balanceOf[_user] -= amount;
267         freezeOfUser[_user] += amount;
268         uint256 _valueI;
269         uint8 _stepI;
270         for(i=0; i<_value.length; i++){
271             _valueI = _value[i];
272             _stepI = _step[i];
273             freezeOf[_stepI].push(uint256(_user)<<96|_valueI);
274         }
275         emit Freeze(_user, amount);
276         return true;
277     }
278 
279     function unFreeze(uint8 _step) onlyController public returns (bool unlockOver) {
280         require(stepLockend[_step]<now && (currUnlockStep==_step || currUnlockSeq==uint256(0)));
281         require(stepUnlockInfo[_step]==false);
282         uint256[] memory currArr = freezeOf[_step];
283         currUnlockStep = _step;
284         if(currUnlockSeq==uint256(0)){
285             currUnlockSeq = currArr.length;
286         }
287         uint256 start = ((currUnlockSeq>99)?(currUnlockSeq-99): 0);
288 
289         uint256 userLockInfo;
290         uint256 _amount;
291         address userAddress;
292         for(uint256 end = currUnlockSeq; end>start; end--){
293             userLockInfo = freezeOf[_step][end-1];
294             _amount = userLockInfo&0xFFFFFFFFFFFFFFFFFFFFFFFF;
295             userAddress = address(userLockInfo>>96);
296             balanceOf[userAddress] += _amount;
297             freezeOfUser[userAddress] = freezeOfUser[userAddress].sub(_amount);
298             emit Unfreeze(userAddress, _amount);
299         }
300         if(start==0){
301             stepUnlockInfo[_step] = true;
302             currUnlockSeq = 0;
303         }else{
304             currUnlockSeq = start;
305         }
306         return true;
307     }
308     
309     function() payable public {
310         require(isContract(controller), "controller is not a contract");
311         bool proxyPayment = TokenController(controller).proxyPayment.value(msg.value)(msg.sender);
312         require(proxyPayment);
313     }
314 
315     function generateTokens(address _user, uint _amount) onlyController userEnough(owner, _amount) public returns (bool) {
316         balanceOf[_user] += _amount;
317         balanceOf[owner] -= _amount;
318         emit Transfer(0, _user, _amount);
319         return true;
320     }
321 
322     function destroyTokens(address _user, uint _amount) onlyController userEnough(_user, _amount) public returns (bool) {
323         require(balanceOf[_user] >= _amount);
324         balanceOf[owner] += _amount;
325         balanceOf[_user] -= _amount;
326         emit Transfer(_user, 0, _amount);
327         emit Burn(_user, _amount);
328         return true;
329     }
330 
331     function changeOwner(address newOwner) onlyOwner public returns (bool) {
332         balanceOf[newOwner] = balanceOf[owner];
333         balanceOf[owner] = 0;
334         owner = newOwner;
335         return true;
336     }
337 
338     function enableTransfers(bool _transfersEnabled) onlyController public {
339         transfersEnabled = _transfersEnabled;
340     }
341 }
342 
343 contract SomeController is Controlled {
344 
345     using SafeMath for uint256;
346 
347     bool public paused;
348 
349     //uint256 public startFundingTime;
350     //uint256 public endFundingTime;
351 
352     uint256 public softCap; //软顶
353     uint256 public hardCap = 5000*10**18; //硬顶
354     
355     uint256 public minFunding = 10*10**18;  //最低起投额
356     //uint256 public maximumFunding; //最高投资额
357     uint256 public tokensPerEther1 = 128000; //比例
358     uint256 public tokensPerEther2 = 91500; //比例
359 
360 
361     uint256 public totalCollected;
362     Token public tokenContract;
363     bool public finalized = false;
364     bool public allowChange = true;
365     address private vaultAddress;
366 
367     bool private initialed = false;
368 
369     event Payment(address indexed _sender, uint256 _ethAmount, uint256 _tokenAmount);
370     event Info256(string name, uint256 msg);
371     event LastFund(uint256 funding, uint256 backValue);
372 
373     constructor(address tokenAddr) public {
374         tokenContract = Token(tokenAddr);
375     }
376 
377     function setLockStep(uint8[] steps, uint[] times) onlyController public {
378         require(steps.length == times.length, "params length different");
379         for(uint i; i<steps.length; i++){
380             tokenContract.addLockStep(steps[i], times[i]);
381         }
382     }
383 
384     /**
385     * @notice Notifies the controller about a transfer, for this PreTokenSale all transfers are allowed by default and no extra notifications are needed
386     * @param _from The origin of the transfer
387     * @param _to The destination of the transfer
388     * @param _amount The amount of the transfer
389     * @return False if the controller does not authorize the transfer
390     */
391     function onTransfer(address _from, address _to, uint _amount) public view returns(bool){
392         if ( _from == vaultAddress) {
393             return true;
394         }
395         _to;
396         _amount;
397         return false;
398     }
399 
400     /**
401      * @notice Notifies the controller about an approval, for this PreTokenSale all
402      * approvals are allowed by default and no extra notifications are needed
403      * @param _owner The address that calls `approve()`
404      * @param _spender The spender in the `approve()` call
405      * @param _amount The amount in the `approve()` call
406      * @return False if the controller does not authorize the approval
407      */
408     function onApprove(address _owner, address _spender, uint _amount) public view returns(bool){
409         if ( _owner == vaultAddress ) {
410             return true;
411         }
412         _spender;
413         _amount;
414         return false;
415     }
416 
417     /// @dev `doPayment()` is an internal function that sends the ether that this
418     ///  contract receives to the `vault` and creates tokens in the address of the
419     ///  `_owner` assuming the PreTokenSale is still accepting funds
420     /// @param _owner The address that will hold the newly created tokens
421 
422     function fixFunding(address[] _owner, uint256[] _value, uint8[] _steps, uint8[] _percents) onlyController public {
423         require(_owner.length == _value.length, "length of address is different with value");
424         require(_steps.length == _percents.length, "length of steps is different with percents");
425         address ownerNow;
426         uint256 valueNow;
427         for(uint i=0; i<_owner.length; i++){
428             ownerNow = _owner[i];
429             valueNow = _value[i];
430             require(tokenContract.generateTokens(ownerNow, valueNow), "generateTokens executed error");
431             //按需冻结投资人资金
432             //freezeAccount(_owner, tokenValue1, tokenValue2);
433             uint256[] memory valueArr = new uint256[](_steps.length);
434             //内层循环必须初始化值，不然第二次执行时，不再初始化，导致值错误而不进入循环体
435             for(uint j=0; j<_steps.length; j++){
436                 valueArr[j] = valueNow*_percents[j]/100;
437             }
438             tokenContract.freeze(ownerNow, valueArr, _steps);
439         }
440     }
441 
442     function changeTokenController(address _newController) onlyController public {
443         tokenContract.changeController(_newController);
444     }
445 
446     /**
447      * 修改所控 Token 合约
448      */
449     function changeToken(address _newToken) onlyController public {
450         tokenContract = Token(_newToken);
451     }
452 
453     function changeVault(address _newVaultAddress) onlyController public {
454         vaultAddress = _newVaultAddress;
455     }
456 
457     /// @notice Pauses the contribution if there is any issue
458     function pauseContribution() onlyController public {
459         paused = true;
460     }
461 
462     /// @notice Resumes the contribution
463     function resumeContribution() onlyController public {
464         paused = false;
465     }
466 
467     modifier notPaused() {
468         require(!paused);
469         _;
470     }
471 
472     // /**
473     //  * 修改Token兑换比率
474     //  */
475     // function changeTokensPerEther(uint256 _newRate) onlyController public {
476     //    require(transfersEnabled==false);
477     //    require(_newRate>0);
478     //    tokensPerEther = _newRate;
479     //    transfersEnabled = true;
480     // }
481 
482 
483     /// @dev Internal function to determine if an address is a contract
484     /// @param _addr The address being queried
485     /// @return True if `_addr` is a contract
486     function isContract(address _addr) constant internal returns (bool) {
487         if (_addr == 0) {
488             return false;
489         }
490         uint256 size;
491         assembly {
492             size := extcodesize(_addr)
493         }
494         return (size > 0);
495     }
496 
497     function claimTokens(address[] tokens) onlyController public {
498         address _token;
499         uint256 balance;
500         for(uint256 i; i<tokens.length; i++){
501             _token = tokens[i];
502             if (_token == 0x0) {
503                 balance = address(this).balance;
504                 if(balance > 0){
505                     msg.sender.transfer(balance);
506                 }
507             }else{
508                 ERC20Token token = ERC20Token(_token);
509                 balance = token.balanceOf(address(this));
510                 token.transfer(msg.sender, balance);
511                 emit ClaimedTokens(_token, msg.sender, balance);
512             }
513         }
514     }
515 
516     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
517 
518 }
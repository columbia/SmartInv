1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         // assert(b > 0); // Solidity automatically throws when dividing by 0
13         uint256 c = a / b;
14         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract ApproveAndCallReceiver {
31     function receiveApproval(
32         address _from, 
33         uint256 _amount, 
34         address _token, 
35         bytes _data
36     ) public;
37 }
38 
39 //normal contract. already compiled as bin
40 contract Controlled {
41     /// @notice The address of the controller is the only address that can call
42     ///  a function with this modifier
43     modifier onlyController { 
44         require(msg.sender == controller); 
45         _; 
46     }
47 
48     //block for check//bool private initialed = false;
49     address public controller;
50 
51     constructor() public {
52       //block for check//require(!initialed);
53       controller = msg.sender;
54       //block for check//initialed = true;
55     }
56 
57     /// @notice Changes the controller of the contract
58     /// @param _newController The new controller of the contract
59     function changeController(address _newController) onlyController public {
60         controller = _newController;
61     }
62 }
63 
64 //abstract contract. used for interface
65 contract TokenController {
66     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
67     /// @param _owner The address that sent the ether to create tokens
68     /// @return True if the ether is accepted, false if it throws
69     function proxyPayment(address _owner) payable public returns(bool);
70 
71     /// @notice Notifies the controller about a token transfer allowing the
72     ///  controller to react if desired
73     /// @param _from The origin of the transfer
74     /// @param _to The destination of the transfer
75     /// @param _amount The amount of the transfer
76     /// @return False if the controller does not authorize the transfer
77     //function onTransfer(address _from, address _to, uint _amount) public returns(bool);
78 
79     /// @notice Notifies the controller about an approval allowing the
80     ///  controller to react if desired
81     /// @param _owner The address that calls `approve()`
82     /// @param _spender The spender in the `approve()` call
83     /// @param _amount The amount in the `approve()` call
84     /// @return False if the controller does not authorize the approval
85     //function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
86 }
87 
88 contract ERC20Token {
89     /* This is a slight change to the ERC20 base standard.
90       function totalSupply() constant returns (uint256 supply);
91       is replaced with:
92       uint256 public totalSupply;
93       This automatically creates a getter function for the totalSupply.
94       This is moved to the base contract since public getter functions are not
95       currently recognised as an implementation of the matching abstract
96       function by the compiler.
97     */
98     /// total amount of tokens
99     uint256 public totalSupply;
100     //function totalSupply() public constant returns (uint256 balance);
101 
102     /// @param _owner The address from which the balance will be retrieved
103     /// @return The balance
104     mapping (address => uint256) public balanceOf;
105     //function balanceOf(address _owner) public constant returns (uint256 balance);
106 
107     /// @notice send `_value` token to `_to` from `msg.sender`
108     /// @param _to The address of the recipient
109     /// @param _value The amount of token to be transferred
110     /// @return Whether the transfer was successful or not
111     function transfer(address _to, uint256 _value) public returns (bool success);
112 
113     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
114     /// @param _from The address of the sender
115     /// @param _to The address of the recipient
116     /// @param _value The amount of token to be transferred
117     /// @return Whether the transfer was successful or not
118     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
119 
120     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
121     /// @param _spender The address of the account able to transfer the tokens
122     /// @param _value The amount of tokens to be approved for transfer
123     /// @return Whether the approval was successful or not
124     function approve(address _spender, uint256 _value) public returns (bool success);
125 
126     /// @param _owner The address of the account owning tokens
127     /// @param _spender The address of the account able to transfer the tokens
128     /// @return Amount of remaining tokens allowed to spent
129     mapping (address => mapping (address => uint256)) public allowance;
130     //function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
131 
132     event Transfer(address indexed _from, address indexed _to, uint256 _value);
133     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
134 }
135 
136 contract TokenI is ERC20Token, Controlled {
137 
138     string public name;                //The Token's name: e.g. DigixDAO Tokens
139     uint8 public decimals = 18;             //Number of decimals of the smallest unit
140     string public symbol;              //An identifier: e.g. REP
141 
142 
143     // ERC20 Methods
144 
145     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
146     ///  its behalf, and then a function is triggered in the contract that is
147     ///  being approved, `_spender`. This allows users to use their tokens to
148     ///  interact with contracts in one function call instead of two
149     /// @param _spender The address of the contract able to transfer the tokens
150     /// @param _amount The amount of tokens to be approved for transfer
151     /// @return True if the function call was successful
152     function approveAndCall(
153         address _spender,
154         uint256 _amount,
155         bytes _extraData
156     ) public returns (bool success);
157 
158 
159     // Generate and destroy tokens
160 
161     /// @notice Generates `_amount` tokens that are assigned to `_owner`
162     /// @param _owner The address that will be assigned the new tokens
163     /// @param _amount The quantity of tokens generated
164     /// @return True if the tokens are generated correctly
165     function generateTokens(address _owner, uint _amount) public returns (bool);
166 
167 
168     /// @notice Burns `_amount` tokens from `_owner`
169     /// @param _owner The address that will lose the tokens
170     /// @param _amount The quantity of tokens to burn
171     /// @return True if the tokens are burned correctly
172     function destroyTokens(address _owner, uint _amount) public returns (bool);
173 
174     /// @notice Enables token holders to transfer their tokens freely if true
175     /// @param _transfersEnabled True if transfers are allowed in the clone
176     function enableTransfers(bool _transfersEnabled) public;
177 
178 
179     // Safety Methods
180 
181     /// @notice This method can be used by the controller to extract mistakenly
182     ///  sent tokens to this contract.
183     /// @param _tokens The address of the token contract that you want to recover
184     ///  set to 0 in case you want to extract ether.
185     function claimTokens(address[] _tokens) public;
186 
187 
188     // Events
189 
190     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
191 }
192 
193 
194 contract Token915 is TokenI {
195     using SafeMath for uint256;
196 
197     address public owner;
198 
199     string public techProvider = "WeYii Tech(https://weyii.co)";
200     string public officialSite = "https://915club.com";
201 
202     mapping (uint8 => uint256[]) public freezeOf; //所有数额，地址与数额合并为uint256，位运算拆分。
203     //解锁信息
204     uint8  currUnlockStep; //当前解锁step
205     uint256 currUnlockSeq; //当前解锁step 内的游标
206 
207     mapping (uint8 => bool) public stepUnlockInfo; //所有锁仓，key 使用序号向上增加，value,是否已解锁。
208     mapping (address => uint256) public freezeOfUser; //用户所有锁仓，方便用户查询自己锁仓余额
209     //mapping (uint8 => uint32) public lastFreezeSeq; //最后的 freezeOf 键值。key: step; value: sequence
210     mapping (uint8 => uint256) public stepLockend; //key:锁仓step，value：解锁时间
211     //uint8[] public lockSteps;
212 
213     bool public transfersEnabled = true;
214 
215     /* This generates a public event on the blockchain that will notify clients */
216     //event Transfer(address indexed from, address indexed to, uint256 value);
217 
218     /* This notifies clients about the amount burnt */
219     event Burn(address indexed from, uint256 value);
220     
221     /* This notifies clients about the amount frozen */
222     event Freeze(address indexed from, uint256 value);
223     
224     /* This notifies clients about the amount unfrozen */
225     event Unfreeze(address indexed from, uint256 value);
226 
227     /* Initializes contract with initial supply tokens to the creator of the contract */
228     constructor(
229         uint256 initialSupply,
230         string tokenName,
231         string tokenSymbol,
232         address initialOwner
233     ) public {
234         name = tokenName;
235         symbol = tokenSymbol;
236         owner = initialOwner;
237         totalSupply = initialSupply*uint256(10)**decimals;
238         balanceOf[owner] = totalSupply;
239     }
240 
241     modifier onlyOwner() {
242         require(msg.sender == owner);
243         _;
244     }
245 
246     modifier ownerOrController(){
247         require(msg.sender == owner || msg.sender == controller);
248         _;
249     }
250 
251     modifier transable(){
252         require(transfersEnabled);
253         _;
254     }
255 
256     modifier ownerOrUser(address user){
257         require(msg.sender == owner || msg.sender == user);
258         _;
259     }
260 
261     modifier userOrController(address user){
262         require(msg.sender == user || msg.sender == owner || msg.sender == controller);
263         _;
264     }
265 
266     //要求真实用户
267     modifier realUser(address user){
268         require(user != 0x0);
269         _;
270     }
271 
272     modifier moreThanZero(uint256 _value){
273         require(_value > 0);
274         _;
275     }
276 
277     /// 余额足够
278     modifier userEnough(address _user, uint256 _amount) {
279         require(balanceOf[_user] >= _amount);
280         _;
281     }
282 
283     /// @dev Internal function to determine if an address is a contract
284     /// @param _addr The address being queried
285     /// @return True if `_addr` is a contract
286     function isContract(address _addr) constant internal returns(bool) {
287         uint size;
288         if (_addr == 0) {
289             return false;
290         }
291         assembly {
292             size := extcodesize(_addr)
293         }
294         return size>0;
295     }
296 
297     /// @dev Internal function to determine if an address is a contract
298     function addLockStep(uint8 _step, uint _endTime) onlyController external returns(bool) {
299         stepLockend[_step] = _endTime;
300     }
301 
302     /* Send coins */
303     function transfer(address _to, uint256 _value) realUser(_to) moreThanZero(_value) transable public returns (bool) {
304         //require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
305         //require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
306         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);                     // Subtract from the sender
307         balanceOf[_to] = balanceOf[_to].add(_value);                            // Add the same to the recipient
308         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
309         return true;
310     }
311 
312     /* Allow another contract to spend some tokens in your behalf */
313     function approve(address _spender, uint256 _value) transable public
314         returns (bool success) {
315         require(_value == 0 || (allowance[msg.sender][_spender] == 0));
316         allowance[msg.sender][_spender] = _value;
317         emit Approval(msg.sender, _spender, _value);
318         return true;
319     }
320 
321 
322     /* decreace allowance*/
323     function unApprove(address _spender, uint256 _value) moreThanZero(_value) transable public
324         returns (bool success) {
325         require(_value == 0 || (allowance[msg.sender][_spender] == 0));
326         allowance[msg.sender][_spender] = allowance[msg.sender][_spender].sub(_value);
327         emit Approval(msg.sender, _spender, _value);
328         return true;
329     }
330 
331 
332     /**
333      * @notice `msg.sender` approves `_spender` to send `_amount` tokens on
334      *  its behalf, and then a function is triggered in the contract that is
335      *  being approved, `_spender`. This allows users to use their tokens to
336      *  interact with contracts in one function call instead of two
337      * @param _spender The address of the contract able to transfer the tokens
338      * @param _amount The amount of tokens to be approved for transfer
339      * @return True if the function call was successful
340      */
341     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) transable public returns (bool success) {
342         require(approve(_spender, _amount));
343 
344         ApproveAndCallReceiver(_spender).receiveApproval(
345             msg.sender,
346             _amount,
347             this,
348             _extraData
349         );
350 
351         return true;
352     }
353 
354     /* A contract attempts to get the coins */
355     function transferFrom(address _from, address _to, uint256 _value) realUser(_from) realUser(_to) moreThanZero(_value) transable public returns (bool success) {
356         require(balanceOf[_from] >= _value);                 // Check if the sender has enough
357         require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
358         require(_value <= allowance[_from][msg.sender]);     // Check allowance
359         balanceOf[_from] = balanceOf[_from].sub(_value);                           // Subtract from the sender
360         balanceOf[_to] = balanceOf[_to].add(_value);                             // Add the same to the recipient
361         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
362         emit Transfer(_from, _to, _value);
363         return true;
364     }
365     
366     function transferMulti(address[] _to, uint256[] _value) transable public returns (bool success, uint256 amount){
367         require(_to.length == _value.length && _to.length <= 1024);
368         uint256 balanceOfSender = balanceOf[msg.sender];
369         uint256 len = _to.length;
370         for(uint256 j; j<len; j++){
371             require(_value[j] <= balanceOfSender); //limit transfer value
372             amount = amount.add(_value[j]);
373         }
374         require(balanceOfSender > amount ); //check enough and not overflow
375         balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount);
376         address _toI;
377         uint256 _valueI;
378         for(uint256 i; i<len; i++){
379             _toI = _to[i];
380             _valueI = _value[i];
381             balanceOf[_toI] = balanceOf[_toI].add(_valueI);
382             emit Transfer(msg.sender, _toI, _valueI);
383         }
384         return (true, amount);
385     }
386     
387     function transferMultiSameVaule(address[] _to, uint256 _value) transable public returns (bool){
388         require(_to.length <= 1024);
389         //uint256 balanceOfSender = balanceOf[msg.sender];
390         uint256 len = _to.length;
391         uint256 amount = _value.mul(len);
392         //require(balanceOfSender - amount < balanceOfSender); //check enough and not overflow
393         //TODO test
394         balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount); //this maybe will check enough automatically
395         address _toI;
396         for(uint256 i; i<len; i++){
397             _toI = _to[i];
398             balanceOf[_toI] = balanceOf[_toI].add(_value);
399             emit Transfer(msg.sender, _toI, _value);
400         }
401         return true;
402     }
403 
404     //冻结账户
405     function freeze(address _user, uint256 _value, uint8 _step) moreThanZero(_value) onlyController public returns (bool success) {
406         require(balanceOf[_user] >= _value);
407         balanceOf[_user] = balanceOf[_user].sub(_value);
408         freezeOfUser[_user] = freezeOfUser[_user].add(_value);
409         freezeOf[_step].push(uint256(_user)<<96|_value);
410         emit Freeze(_user, _value);
411         return true;
412     }
413 
414 
415     //event info(string name, uint32 value);
416     //event info256(string name, uint256 value);
417     
418     //为用户解锁账户资金
419     function unFreeze(uint8 _step) onlyController public returns (bool unlockOver) {
420         require(stepLockend[_step]<now && (currUnlockStep==_step || currUnlockSeq==uint256(0)));
421         require(stepUnlockInfo[_step]==false);
422         uint256[] memory currArr = freezeOf[_step];
423         currUnlockStep = _step;
424         if(currUnlockSeq==uint256(0)){
425             currUnlockSeq = currArr.length;
426         }
427         uint256 start = ((currUnlockSeq>99)?(currUnlockSeq-99): 0);
428 
429         uint256 userLockInfo;
430         uint256 _amount;
431         address userAddress;
432         for(uint256 end = currUnlockSeq; end>start; end--){
433             userLockInfo = freezeOf[_step][end-1];
434             _amount = userLockInfo&0xFFFFFFFFFFFFFFFFFFFFFFFF;
435             userAddress = address(userLockInfo>>96);
436             balanceOf[userAddress] += _amount;
437             freezeOfUser[userAddress] = freezeOfUser[userAddress].sub(_amount);
438             emit Unfreeze(userAddress, _amount);
439         }
440         if(start==0){
441             stepUnlockInfo[_step] = true;
442             currUnlockSeq = 0;
443         }else{
444             currUnlockSeq = start;
445         }
446         return true;
447     }
448     
449     //accept ether
450     function() payable public {
451         //屏蔽控制方的合约类型检查，以兼容发行方无控制合约的情况。
452         require(isContract(controller));
453         bool proxyPayment = TokenController(controller).proxyPayment.value(msg.value)(msg.sender);
454         require(proxyPayment);
455     }
456 
457 ////////////////
458 // Generate and destroy tokens
459 ////////////////
460 
461     /// @notice Generates `_amount` tokens that are assigned to `_owner`
462     /// @param _user The address that will be assigned the new tokens
463     /// @param _amount The quantity of tokens generated
464     /// @return True if the tokens are generated correctly
465     function generateTokens(address _user, uint _amount) onlyController public returns (bool) {
466         //require(balanceOf[owner] >= _amount);
467         balanceOf[_user] += _amount;
468         balanceOf[owner] -= _amount;
469         emit Transfer(0, _user, _amount);
470         return true;
471     }
472 
473     /// @notice Burns `_amount` tokens from `_owner`
474     /// @param _user The address that will lose the tokens
475     /// @param _amount The quantity of tokens to burn
476     /// @return True if the tokens are burned correctly
477     function destroyTokens(address _user, uint _amount) onlyController userEnough(_user, _amount) public returns (bool) {
478         require(balanceOf[_user] >= _amount);
479         balanceOf[owner] += _amount;
480         balanceOf[_user] -= _amount;
481         emit Transfer(_user, 0, _amount);
482         emit Burn(_user, _amount);
483         return true;
484     }
485 
486     function changeOwner(address newOwner) onlyOwner public returns (bool) {
487         balanceOf[newOwner] = balanceOf[owner];
488         balanceOf[owner] = 0;
489         owner = newOwner;
490         return true;
491     }
492 
493 ////////////////
494 // Enable tokens transfers
495 ////////////////
496 
497     /// @notice Enables token holders to transfer their tokens freely if true
498     /// @param _transfersEnabled True if transfers are allowed in the clone
499     function enableTransfers(bool _transfersEnabled) onlyController public {
500         transfersEnabled = _transfersEnabled;
501     }
502 
503 //////////
504 // Safety Methods
505 //////////
506 
507     /// @notice This method can be used by the controller to extract mistakenly
508     ///  sent tokens to this contract.
509     ///  set to 0 in case you want to extract ether.
510     function claimTokens(address[] tokens) onlyOwner public {
511         address _token;
512         uint256 balance;
513         for(uint256 i; i<tokens.length; i++){
514             _token = tokens[i];
515             if (_token == 0x0) {
516                 balance = address(this).balance;
517                 if(balance > 0){
518                     owner.transfer(balance);
519                 }
520             }else{
521                 ERC20Token token = ERC20Token(_token);
522                 balance = token.balanceOf(address(this));
523                 token.transfer(owner, balance);
524                 emit ClaimedTokens(_token, owner, balance);
525             }
526         }
527     }
528 }
1 pragma solidity ^0.4.18;
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
51     function Controlled() public {
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
77     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
78 
79     /// @notice Notifies the controller about an approval allowing the
80     ///  controller to react if desired
81     /// @param _owner The address that calls `approve()`
82     /// @param _spender The spender in the `approve()` call
83     /// @param _amount The amount in the `approve()` call
84     /// @return False if the controller does not authorize the approval
85     function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
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
139     uint8 public decimals;             //Number of decimals of the smallest unit
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
183     /// @param _token The address of the token contract that you want to recover
184     ///  set to 0 in case you want to extract ether.
185     function claimTokens(address _token) public;
186 
187 
188     // Events
189 
190     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
191 }
192 
193 contract Token is TokenI {
194     using SafeMath for uint256;
195 
196     string public techProvider = "WeYii Tech";
197     string public officialSite = "http://www.beautybloc.io";
198 
199     address public owner;
200 
201     struct FreezeInfo {
202         address user;
203         uint256 amount;
204     }
205     //Key1: step(募资阶段); Key2: user sequence(用户序列)
206     mapping (uint8 => mapping (uint8 => FreezeInfo)) public freezeOf; //所有锁仓，key 使用序号向上增加，方便程序查询。
207     mapping (uint8 => uint8) public lastFreezeSeq; //最后的 freezeOf 键值。key: step; value: sequence
208     mapping (uint8 => uint8) internal unlockTime;
209 
210     bool public transfersEnabled;
211 
212     /* This generates a public event on the blockchain that will notify clients */
213     //event Transfer(address indexed from, address indexed to, uint256 value);
214 
215     /* This notifies clients about the amount burnt */
216     event Burn(address indexed from, uint256 value);
217     
218     /* This notifies clients about the amount frozen */
219     event Freeze(address indexed from, uint256 value);
220     
221     /* This notifies clients about the amount unfrozen */
222     event Unfreeze(address indexed from, uint256 value);
223 
224     /* Initializes contract with initial supply tokens to the creator of the contract */
225     function Token(
226         uint256 initialSupply,
227         string tokenName,
228         uint8 decimalUnits,
229         string tokenSymbol,
230         bool transfersEnable
231         ) public {
232         balanceOf[msg.sender] = initialSupply;
233         totalSupply = initialSupply;
234         name = tokenName;
235         symbol = tokenSymbol;
236         decimals = decimalUnits;
237         transfersEnabled = transfersEnable;
238         owner = msg.sender;
239     }
240 
241     modifier onlyOwner() {
242         require(msg.sender == owner);
243         _;
244     }
245 
246     modifier ownerOrController() {
247         require(msg.sender == owner || msg.sender == controller);
248         _;
249     }
250 
251     modifier ownerOrUser(address user){
252         require(msg.sender == owner || msg.sender == user);
253         _;
254     }
255 
256     modifier transable(){
257         require(transfersEnabled);
258         _;
259     }
260 
261     modifier realUser(address user){
262         if(user == 0x0){
263             revert();
264         }
265         _;
266     }
267 
268     modifier moreThanZero(uint256 _value){
269         if (_value <= 0){
270             revert();
271         }
272         _;
273     }
274 
275     modifier moreOrEqualZero(uint256 _value){
276         if(_value < 0){
277             revert();
278         }
279         _;
280     }
281 
282     /// @dev Internal function to determine if an address is a contract
283     /// @param _addr The address being queried
284     /// @return True if `_addr` is a contract
285     function isContract(address _addr) constant internal returns(bool) {
286         uint size;
287         if (_addr == 0) {
288             return false;
289         }
290         assembly {
291             size := extcodesize(_addr)
292         }
293         return size>0;
294     }
295 
296     /* Send coins */
297     function transfer(address _to, uint256 _value) realUser(_to) moreThanZero(_value) transable public returns (bool) {
298         require(balanceOf[msg.sender] >= _value);          // Check if the sender has enough
299         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
300         balanceOf[_to] = balanceOf[_to].add(_value);
301         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
302         return true;
303     }
304 
305     /* Allow another contract to spend some tokens in your behalf */
306     function approve(address _spender, uint256 _value) moreThanZero(_value) transable public
307         returns (bool success) {
308         allowance[msg.sender][_spender] = _value;
309         return true;
310     }
311 
312     /**
313      * @notice `msg.sender` approves `_spender` to send `_amount` tokens on
314      *  its behalf, and then a function is triggered in the contract that is
315      *  being approved, `_spender`. This allows users to use their tokens to
316      *  interact with contracts in one function call instead of two
317      * @param _spender The address of the contract able to transfer the tokens
318      * @param _amount The amount of tokens to be approved for transfer
319      * @return True if the function call was successful
320      */
321     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) transable public returns (bool success) {
322         require(approve(_spender, _amount));
323 
324         ApproveAndCallReceiver(_spender).receiveApproval(
325             msg.sender,
326             _amount,
327             this,
328             _extraData
329         );
330 
331         return true;
332     }
333 
334     /* A contract attempts to get the coins */
335     function transferFrom(address _from, address _to, uint256 _value) realUser(_from) realUser(_to) moreThanZero(_value) transable public returns (bool success) {
336         require(balanceOf[_from] >= _value);                 // Check if the sender has enough
337         require(balanceOf[_to] + _value > balanceOf[_to]);   // Check for overflows
338         require(_value <= allowance[_from][msg.sender]);     // Check allowance
339         balanceOf[_from] = balanceOf[_from].sub(_value);                           // Subtract from the sender
340         balanceOf[_to] = balanceOf[_to].add(_value);                             // Add the same to the recipient
341         allowance[_from][msg.sender] = allowance[_from][msg.sender].add(_value);
342         Transfer(_from, _to, _value);
343         return true;
344     }
345 
346     function transferMulti(address[] _to, uint256[] _value) transable public returns (uint256 amount){
347         require(_to.length == _value.length && _to.length <= 1024);
348         uint256 balanceOfSender = balanceOf[msg.sender];
349         uint256 len = _to.length;
350         for(uint256 j; j<len; j++){
351             require(_value[j] <= balanceOfSender); //limit transfer value
352             amount = amount.add(_value[j]);
353         }
354         require(balanceOfSender - amount < balanceOfSender); //check enough and not overflow
355         balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount);
356         for(uint256 i; i<len; i++){
357             address _toI = _to[i];
358             uint256 _valueI = _value[i];
359             balanceOf[_toI] = balanceOf[_toI].add(_valueI);
360             Transfer(msg.sender, _toI, _valueI);
361         }
362     }
363     
364     //只能自己或者 owner 才能冻结账户
365     function freeze(address _user, uint256 _value, uint8 _step) moreThanZero(_value) onlyController public returns (bool success) {
366         require(balanceOf[_user] >= _value);
367         balanceOf[_user] = balanceOf[_user] - _value;
368         freezeOf[_step][lastFreezeSeq[_step]] = FreezeInfo({user:_user, amount:_value});
369         lastFreezeSeq[_step]++;
370         Freeze(_user, _value);
371         return true;
372     }
373 
374     event infoBool(string name, bool value);
375     event infoAddr(string name, address addr);
376     event info(string name, uint8 value);
377     event info256(string name, uint256 value);
378     
379     //为用户解锁账户资金
380     function unFreeze(uint8 _step) onlyOwner public returns (bool unlockOver) {
381         //_end = length of freezeOf[_step]
382         uint8 _end = lastFreezeSeq[_step];
383         require(_end > 0);
384         //info("_end", _end);
385         unlockOver = (_end <= 99);
386         uint8 _start = (_end > 99) ? _end-100 : 0;
387         //info("_start", _start);
388         for(; _end>_start; _end--){
389             FreezeInfo storage fInfo = freezeOf[_step][_end-1];
390             uint256 _amount = fInfo.amount;
391             balanceOf[fInfo.user] += _amount;
392             delete freezeOf[_step][_end-1];
393             lastFreezeSeq[_step]--;
394             Unfreeze(fInfo.user, _amount);
395         }
396     }
397     
398     //accept ether
399     function() payable public {
400         //屏蔽控制方的合约类型检查，以兼容发行方无控制合约的情况。
401         require(isContract(controller));
402         bool proxyPayment = TokenController(controller).proxyPayment.value(msg.value)(msg.sender);
403         require(proxyPayment);
404     }
405 
406     ////////////////
407     // Generate and destroy tokens
408     ////////////////
409 
410     /// @notice Generates `_amount` tokens that are assigned to `_owner`
411     /// @param _user The address that will be assigned the new tokens
412     /// @param _amount The quantity of tokens generated
413     /// @return True if the tokens are generated correctly
414     function generateTokens(address _user, uint _amount) onlyController public returns (bool) {
415         require(balanceOf[owner] >= _amount);
416         balanceOf[_user] += _amount;
417         balanceOf[owner] -= _amount;
418         Transfer(0, _user, _amount);
419         return true;
420     }
421 
422     /// @notice Burns `_amount` tokens from `_owner`
423     /// @param _user The address that will lose the tokens
424     /// @param _amount The quantity of tokens to burn
425     /// @return True if the tokens are burned correctly
426     function destroyTokens(address _user, uint _amount) onlyOwner public returns (bool) {
427         require(balanceOf[_user] >= _amount);
428         balanceOf[owner] += _amount;
429         balanceOf[_user] -= _amount;
430         Transfer(_user, 0, _amount);
431         Burn(_user, _amount);
432         return true;
433     }
434 
435     ////////////////
436     // Enable tokens transfers
437     ////////////////
438 
439     /// @notice Enables token holders to transfer their tokens freely if true
440     /// @param _transfersEnabled True if transfers are allowed in the clone
441     function enableTransfers(bool _transfersEnabled) onlyOwner public {
442         transfersEnabled = _transfersEnabled;
443     }
444 
445     //////////
446     // Safety Methods
447     //////////
448 
449     /// @notice This method can be used by the controller to extract mistakenly
450     ///  sent tokens to this contract.
451     ///  set to 0 in case you want to extract ether.
452     function claimTokens(address _token) onlyController public {
453         if (_token == 0x0) {
454             controller.transfer(this.balance);
455             return;
456         }
457 
458         Token token = Token(_token);
459         uint balance = token.balanceOf(this);
460         token.transfer(controller, balance);
461         ClaimedTokens(_token, controller, balance);
462     }
463 
464     function changeOwner(address newOwner) onlyOwner public returns (bool) {
465         balanceOf[newOwner] += balanceOf[owner];
466         balanceOf[owner] = 0;
467         owner = newOwner;
468         return true;
469     }
470 }
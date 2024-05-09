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
136 
137 contract TokenI is ERC20Token, Controlled {
138 
139     string public name;                //The Token's name: e.g. DigixDAO Tokens
140     uint8 public decimals;             //Number of decimals of the smallest unit
141     string public symbol;              //An identifier: e.g. REP
142 
143 
144     // ERC20 Methods
145 
146     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
147     ///  its behalf, and then a function is triggered in the contract that is
148     ///  being approved, `_spender`. This allows users to use their tokens to
149     ///  interact with contracts in one function call instead of two
150     /// @param _spender The address of the contract able to transfer the tokens
151     /// @param _amount The amount of tokens to be approved for transfer
152     /// @return True if the function call was successful
153     function approveAndCall(
154         address _spender,
155         uint256 _amount,
156         bytes _extraData
157     ) public returns (bool success);
158 
159 
160     // Generate and destroy tokens
161 
162     /// @notice Generates `_amount` tokens that are assigned to `_owner`
163     /// @param _owner The address that will be assigned the new tokens
164     /// @param _amount The quantity of tokens generated
165     /// @return True if the tokens are generated correctly
166     function generateTokens(address _owner, uint _amount) public returns (bool);
167 
168 
169     /// @notice Burns `_amount` tokens from `_owner`
170     /// @param _owner The address that will lose the tokens
171     /// @param _amount The quantity of tokens to burn
172     /// @return True if the tokens are burned correctly
173     function destroyTokens(address _owner, uint _amount) public returns (bool);
174 
175     /// @notice Enables token holders to transfer their tokens freely if true
176     /// @param _transfersEnabled True if transfers are allowed in the clone
177     function enableTransfers(bool _transfersEnabled) public;
178 
179 
180     // Safety Methods
181 
182     /// @notice This method can be used by the controller to extract mistakenly
183     ///  sent tokens to this contract.
184     /// @param _token The address of the token contract that you want to recover
185     ///  set to 0 in case you want to extract ether.
186     function claimTokens(address _token) public;
187 
188 
189     // Events
190 
191     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
192 }
193 
194 contract Token is TokenI {
195     using SafeMath for uint256;
196 
197     string public techProvider = "WeYii Tech";
198     string public officialSite = "http://www.beautybloc.io";
199 
200     address public owner;
201 
202     struct FreezeInfo {
203         address user;
204         uint256 amount;
205     }
206     //Key1: step(募资阶段); Key2: user sequence(用户序列)
207     mapping (uint8 => mapping (uint8 => FreezeInfo)) public freezeOf; //所有锁仓，key 使用序号向上增加，方便程序查询。
208     mapping (uint8 => uint8) public lastFreezeSeq; //最后的 freezeOf 键值。key: step; value: sequence
209     mapping (uint8 => uint8) internal unlockTime;
210 
211     bool public transfersEnabled;
212 
213     /* This generates a public event on the blockchain that will notify clients */
214     //event Transfer(address indexed from, address indexed to, uint256 value);
215 
216     /* This notifies clients about the amount burnt */
217     event Burn(address indexed from, uint256 value);
218     
219     /* This notifies clients about the amount frozen */
220     event Freeze(address indexed from, uint256 value);
221     
222     /* This notifies clients about the amount unfrozen */
223     event Unfreeze(address indexed from, uint256 value);
224 
225     /* Initializes contract with initial supply tokens to the creator of the contract */
226     function Token(
227         uint256 initialSupply,
228         string tokenName,
229         uint8 decimalUnits,
230         string tokenSymbol,
231         bool transfersEnable
232         ) public {
233         balanceOf[msg.sender] = initialSupply;
234         totalSupply = initialSupply;
235         name = tokenName;
236         symbol = tokenSymbol;
237         decimals = decimalUnits;
238         transfersEnabled = transfersEnable;
239         owner = msg.sender;
240     }
241 
242     modifier onlyOwner() {
243         require(msg.sender == owner);
244         _;
245     }
246 
247     modifier ownerOrController() {
248         require(msg.sender == owner || msg.sender == controller);
249         _;
250     }
251 
252     modifier ownerOrUser(address user){
253         require(msg.sender == owner || msg.sender == user);
254         _;
255     }
256 
257     modifier realUser(address user){
258         if(user == 0x0){
259             revert();
260         }
261         _;
262     }
263 
264     modifier moreThanZero(uint256 _value){
265         if (_value <= 0){
266             revert();
267         }
268         _;
269     }
270 
271     modifier moreOrEqualZero(uint256 _value){
272         if(_value < 0){
273             revert();
274         }
275         _;
276     }
277 
278     /// @dev Internal function to determine if an address is a contract
279     /// @param _addr The address being queried
280     /// @return True if `_addr` is a contract
281     function isContract(address _addr) constant internal returns(bool) {
282         uint size;
283         if (_addr == 0) {
284             return false;
285         }
286         assembly {
287             size := extcodesize(_addr)
288         }
289         return size>0;
290     }
291 
292     /* Send coins */
293     function transfer(address _to, uint256 _value) realUser(_to) moreThanZero(_value) public returns (bool) {
294         //infoAddr('msg.sender', msg.sender);
295         //infoBool('typeOf msg.sender', isContract(msg.sender));
296         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
297         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
298         balanceOf[msg.sender] = balanceOf[msg.sender] - _value;                     // Subtract from the sender
299         balanceOf[_to] = balanceOf[_to] + _value;                            // Add the same to the recipient
300         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
301         return true;
302     }
303 
304     /* Allow another contract to spend some tokens in your behalf */
305     function approve(address _spender, uint256 _value) moreThanZero(_value) public
306         returns (bool success) {
307         allowance[msg.sender][_spender] = _value;
308         return true;
309     }
310 
311     /**
312      * @notice `msg.sender` approves `_spender` to send `_amount` tokens on
313      *  its behalf, and then a function is triggered in the contract that is
314      *  being approved, `_spender`. This allows users to use their tokens to
315      *  interact with contracts in one function call instead of two
316      * @param _spender The address of the contract able to transfer the tokens
317      * @param _amount The amount of tokens to be approved for transfer
318      * @return True if the function call was successful
319      */
320     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
321         require(approve(_spender, _amount));
322 
323         ApproveAndCallReceiver(_spender).receiveApproval(
324             msg.sender,
325             _amount,
326             this,
327             _extraData
328         );
329 
330         return true;
331     }
332 
333     /* A contract attempts to get the coins */
334     function transferFrom(address _from, address _to, uint256 _value) realUser(_from) realUser(_to) moreThanZero(_value) public returns (bool success) {
335         require(balanceOf[_from] >= _value);                 // Check if the sender has enough
336         require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
337         require(_value <= allowance[_from][msg.sender]);     // Check allowance
338         balanceOf[_from] = balanceOf[_from] - _value;                           // Subtract from the sender
339         balanceOf[_to] = balanceOf[_to] + _value;                             // Add the same to the recipient
340         allowance[_from][msg.sender] = allowance[_from][msg.sender] + _value;
341         Transfer(_from, _to, _value);
342         return true;
343     }
344     
345     function transferMulti(address[] _to, uint256[] _value) public returns (uint256 amount){
346         require(_to.length == _value.length);
347         uint8 len = uint8(_to.length);
348         for(uint8 j; j<len; j++){
349             amount += _value[j];
350         }
351         require(balanceOf[msg.sender] >= amount);
352         for(uint8 i; i<len; i++){
353             address _toI = _to[i];
354             uint256 _valueI = _value[i];
355             balanceOf[_toI] += _valueI;
356             balanceOf[msg.sender] -= _valueI;
357             Transfer(msg.sender, _toI, _valueI);
358         }
359     }
360     
361     //只能自己或者 owner 才能冻结账户
362     function freeze(address _user, uint256 _value, uint8 _step) moreThanZero(_value) onlyController public returns (bool success) {
363         //info256("balanceOf[_user]", balanceOf[_user]);
364         require(balanceOf[_user] >= _value);
365         balanceOf[_user] = balanceOf[_user] - _value;
366         freezeOf[_step][lastFreezeSeq[_step]] = FreezeInfo({user:_user, amount:_value});
367         lastFreezeSeq[_step]++;
368         Freeze(_user, _value);
369         return true;
370     }
371 
372     event infoBool(string name, bool value);
373     event infoAddr(string name, address addr);
374     event info(string name, uint8 value);
375     event info256(string name, uint256 value);
376     
377     //为用户解锁账户资金
378     function unFreeze(uint8 _step) onlyOwner public returns (bool unlockOver) {
379         //_end = length of freezeOf[_step]
380         uint8 _end = lastFreezeSeq[_step];
381         require(_end > 0);
382         //info("_end", _end);
383         unlockOver = (_end <= 99);
384         uint8 _start = (_end > 99) ? _end-100 : 0;
385         //info("_start", _start);
386         for(; _end>_start; _end--){
387             FreezeInfo storage fInfo = freezeOf[_step][_end-1];
388             uint256 _amount = fInfo.amount;
389             balanceOf[fInfo.user] += _amount;
390             delete freezeOf[_step][_end-1];
391             lastFreezeSeq[_step]--;
392             Unfreeze(fInfo.user, _amount);
393         }
394     }
395     
396     //accept ether
397     function() payable public {
398         //屏蔽控制方的合约类型检查，以兼容发行方无控制合约的情况。
399         require(isContract(controller));
400         bool proxyPayment = TokenController(controller).proxyPayment.value(msg.value)(msg.sender);
401         require(proxyPayment);
402     }
403 
404     ////////////////
405     // Generate and destroy tokens
406     ////////////////
407 
408     /// @notice Generates `_amount` tokens that are assigned to `_owner`
409     /// @param _user The address that will be assigned the new tokens
410     /// @param _amount The quantity of tokens generated
411     /// @return True if the tokens are generated correctly
412     function generateTokens(address _user, uint _amount) onlyController public returns (bool) {
413         require(balanceOf[owner] >= _amount);
414         balanceOf[_user] += _amount;
415         balanceOf[owner] -= _amount;
416         Transfer(0, _user, _amount);
417         return true;
418     }
419 
420     /// @notice Burns `_amount` tokens from `_owner`
421     /// @param _user The address that will lose the tokens
422     /// @param _amount The quantity of tokens to burn
423     /// @return True if the tokens are burned correctly
424     function destroyTokens(address _user, uint _amount) onlyOwner public returns (bool) {
425         balanceOf[owner] += _amount;
426         balanceOf[_user] -= _amount;
427         Transfer(_user, 0, _amount);
428         Burn(_user, _amount);
429         return true;
430     }
431 
432     ////////////////
433     // Enable tokens transfers
434     ////////////////
435 
436     /// @notice Enables token holders to transfer their tokens freely if true
437     /// @param _transfersEnabled True if transfers are allowed in the clone
438     function enableTransfers(bool _transfersEnabled) onlyOwner public {
439         transfersEnabled = _transfersEnabled;
440     }
441 
442     //////////
443     // Safety Methods
444     //////////
445 
446     /// @notice This method can be used by the controller to extract mistakenly
447     ///  sent tokens to this contract.
448     ///  set to 0 in case you want to extract ether.
449     function claimTokens(address _token) onlyController public {
450         if (_token == 0x0) {
451             controller.transfer(this.balance);
452             return;
453         }
454 
455         Token token = Token(_token);
456         uint balance = token.balanceOf(this);
457         token.transfer(controller, balance);
458         ClaimedTokens(_token, controller, balance);
459     }
460 
461     function changeOwner(address newOwner) onlyOwner public returns (bool) {
462         balanceOf[newOwner] = balanceOf[owner];
463         balanceOf[owner] = 0;
464         owner = newOwner;
465         return true;
466     }
467 }
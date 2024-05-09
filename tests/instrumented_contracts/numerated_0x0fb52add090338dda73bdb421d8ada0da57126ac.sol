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
193 contract Token is TokenI {
194     using SafeMath for uint256;
195 
196     string public techProvider = "WeYii Tech";
197     string public officialSite = "http://www.beautybloc.io";
198 
199     //owner是最初的币持有者。对比之下，controller 是合约操作者
200     address public owner;
201 
202     struct FreezeInfo {
203         address user;
204         uint256 amount;
205     }
206     //Key1: step(募资阶段); Key2: user sequence(用户序列)
207     mapping (uint8 => mapping (uint32 => FreezeInfo)) public freezeOf; //所有锁仓，key 使用序号向上增加，方便程序查询。
208     mapping (uint8 => uint32) public lastFreezeSeq; //最后的 freezeOf 键值。key: step; value: sequence
209     //mapping (uint8 => uint) internal unlockTime;
210 
211     bool public transfersEnabled = true;
212 
213     /* This generates a public event on the blockchain that will notify clients */
214     /* This notifies clients about the amount burnt */
215     event Burn(address indexed from, uint256 value);
216     
217     /* This notifies clients about the amount frozen */
218     event Freeze(address indexed from, uint256 value);
219     
220     /* This notifies clients about the amount unfrozen */
221     event Unfreeze(address indexed from, uint256 value);
222 
223     event TransferMulti(uint256 userLen, uint256 valueAmount);
224 
225     /* Initializes contract with initial supply tokens to the creator of the contract */
226     constructor(
227         uint256 initialSupply,
228         string tokenName,
229         string tokenSymbol,
230         address initialOwner
231         ) public {
232         owner = initialOwner;
233         balanceOf[owner] = initialSupply;
234         totalSupply = initialSupply;
235         name = tokenName;
236         symbol = tokenSymbol;
237     }
238 
239     modifier onlyOwner() {
240         require(msg.sender == owner);
241         _;
242     }
243 
244     modifier ownerOrController() {
245         require(msg.sender == owner || msg.sender == controller);
246         _;
247     }
248 
249     modifier ownerOrUser(address user){
250         require(msg.sender == owner || msg.sender == user);
251         _;
252     }
253 
254     modifier userOrController(address user){
255         require(msg.sender == user || msg.sender == owner || msg.sender == controller);
256         _;
257     }
258 
259     modifier transable(){
260         require(transfersEnabled);
261         _;
262     }
263 
264     modifier realUser(address user){
265         if(user == 0x0){
266             revert();
267         }
268         _;
269     }
270 
271     modifier moreThanZero(uint256 _value){
272         if (_value <= 0){
273             revert();
274         }
275         _;
276     }
277 
278     modifier moreOrEqualZero(uint256 _value){
279         if(_value < 0){
280             revert();
281         }
282         _;
283     }
284 
285     /// @dev Internal function to determine if an address is a contract
286     /// @param _addr The address being queried
287     /// @return True if `_addr` is a contract
288     function isContract(address _addr) constant internal returns(bool) {
289         uint size;
290         if (_addr == 0) {
291             return false;
292         }
293         assembly {
294             size := extcodesize(_addr)
295         }
296         return size>0;
297     }
298 
299     /* Send coins */
300     function transfer(address _to, uint256 _value) realUser(_to) moreThanZero(_value) transable public returns (bool) {
301         require(balanceOf[msg.sender] >= _value);          // Check if the sender has enough
302         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
303         balanceOf[_to] = balanceOf[_to].add(_value);
304         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
305         return true;
306     }
307 
308     /* Allow another contract to spend some tokens in your behalf */
309     function approve(address _spender, uint256 _value) transable public returns (bool success) {
310         require(_value == 0 || (allowance[msg.sender][_spender] == 0));
311         allowance[msg.sender][_spender] = _value;
312         emit Approval(msg.sender, _spender, _value);
313         return true;
314     }
315 
316     /**
317      * @notice `msg.sender` approves `_spender` to send `_amount` tokens on
318      *  its behalf, and then a function is triggered in the contract that is
319      *  being approved, `_spender`. This allows users to use their tokens to
320      *  interact with contracts in one function call instead of two
321      * @param _spender The address of the contract able to transfer the tokens
322      * @param _amount The amount of tokens to be approved for transfer
323      * @return True if the function call was successful
324      */
325     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) transable public returns (bool success) {
326         require(approve(_spender, _amount));
327 
328         ApproveAndCallReceiver(_spender).receiveApproval(
329             msg.sender,
330             _amount,
331             this,
332             _extraData
333         );
334 
335         return true;
336     }
337 
338     /* A contract attempts to get the coins */
339     function transferFrom(address _from, address _to, uint256 _value) realUser(_from) realUser(_to) moreThanZero(_value) transable public returns (bool success) {
340         require(balanceOf[_from] >= _value);                 // Check if the sender has enough
341         require(balanceOf[_to] + _value > balanceOf[_to]);   // Check for overflows
342         require(_value <= allowance[_from][msg.sender]);     // Check allowance
343         balanceOf[_from] = balanceOf[_from].sub(_value);                           // Subtract from the sender
344         balanceOf[_to] = balanceOf[_to].add(_value);                             // Add the same to the recipient
345         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
346         emit Transfer(_from, _to, _value);
347         return true;
348     }
349 
350     function transferMulti(address[] _to, uint256[] _value) transable public returns (uint256 amount){
351         require(_to.length == _value.length && _to.length <= 1024);
352         uint256 balanceOfSender = balanceOf[msg.sender];
353         uint256 len = _to.length;
354         for(uint256 j; j<len; j++){
355             require(_value[j] <= balanceOfSender); //limit transfer value
356             amount = amount.add(_value[j]);
357         }
358         require(balanceOfSender - amount < balanceOfSender); //check enough and not overflow
359         balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount);
360         for(uint256 i; i<len; i++){
361             address _toI = _to[i];
362             uint256 _valueI = _value[i];
363             balanceOf[_toI] = balanceOf[_toI].add(_valueI);
364             emit Transfer(msg.sender, _toI, _valueI);
365         }
366         emit TransferMulti(len, amount);
367     }
368     
369     //对多人按相同数量转账
370     function transferMultiSameVaule(address[] _to, uint256 _value) transable public returns (bool success){
371         uint256 len = _to.length;
372         uint256 amount = _value.mul(len);
373         balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount); //this will check enough automatically
374         for(uint256 i; i<len; i++){
375             address _toI = _to[i];
376             balanceOf[_toI] = balanceOf[_toI].add(_value);
377             emit Transfer(msg.sender, _toI, _value);
378         }
379         emit TransferMulti(len, amount);
380         return true;
381     }
382     
383     //只能自己或者 owner,controller 才能冻结账户
384     function freeze(address _user, uint256 _value, uint8 _step) moreThanZero(_value) userOrController(_user) public returns (bool success) {
385         //info256("balanceOf[_user]", balanceOf[_user]);
386         require(balanceOf[_user] >= _value);
387         balanceOf[_user] = balanceOf[_user] - _value;
388         freezeOf[_step][lastFreezeSeq[_step]] = FreezeInfo({user:_user, amount:_value});
389         lastFreezeSeq[_step]++;
390         emit Freeze(_user, _value);
391         return true;
392     }
393 
394     //event infoBool(string name, bool value);
395     //event infoAddr(string name, address addr);
396     //event info(string name, uint32 value);
397     //event info256(string name, uint256 value);
398     
399     //为用户解锁账户资金
400     function unFreeze(uint8 _step) ownerOrController public returns (bool unlockOver) {
401         //_end = length of freezeOf[_step]
402         uint32 _end = lastFreezeSeq[_step];
403         require(_end > 0);
404         //info("_end", _end);
405         unlockOver = (_end <= 99);
406         uint32 _start = (_end > 99) ? _end-100 : 0;
407         //info("_start", _start);
408         for(; _end>_start; _end--){
409             FreezeInfo storage fInfo = freezeOf[_step][_end-1];
410             uint256 _amount = fInfo.amount;
411             balanceOf[fInfo.user] += _amount;
412             delete freezeOf[_step][_end-1];
413             lastFreezeSeq[_step]--;
414             emit Unfreeze(fInfo.user, _amount);
415         }
416     }
417     
418     //accept ether
419     function() payable public {
420         //屏蔽控制方的合约类型检查，以兼容发行方无控制合约的情况。
421         require(isContract(controller));
422         bool proxyPayment = TokenController(controller).proxyPayment.value(msg.value)(msg.sender);
423         require(proxyPayment);
424     }
425 
426     ////////////////
427     // Generate and destroy tokens
428     ////////////////
429 
430     /// @notice Generates `_amount` tokens that are assigned to `_owner`
431     /// @param _user The address that will be assigned the new tokens
432     /// @param _amount The quantity of tokens generated
433     /// @return True if the tokens are generated correctly
434     function generateTokens(address _user, uint _amount) onlyController public returns (bool) {
435         require(balanceOf[owner] >= _amount);
436         balanceOf[_user] += _amount;
437         balanceOf[owner] -= _amount;
438         emit Transfer(0, _user, _amount);
439         return true;
440     }
441 
442     /// @notice Burns `_amount` tokens from `_owner`
443     /// @param _user The address that will lose the tokens
444     /// @param _amount The quantity of tokens to burn
445     /// @return True if the tokens are burned correctly
446     function destroyTokens(address _user, uint _amount) onlyController public returns (bool) {
447         require(balanceOf[_user] >= _amount);
448         balanceOf[owner] += _amount;
449         balanceOf[_user] -= _amount;
450         emit Transfer(_user, 0, _amount);
451         emit Burn(_user, _amount);
452         return true;
453     }
454 
455     ////////////////
456     // Enable tokens transfers
457     ////////////////
458 
459     /// @notice Enables token holders to transfer their tokens freely if true
460     /// @param _transfersEnabled True if transfers are allowed in the clone
461     function enableTransfers(bool _transfersEnabled) ownerOrController public {
462         transfersEnabled = _transfersEnabled;
463     }
464 
465     //////////
466     // Safety Methods
467     //////////
468 
469     /// @notice This method can be used by the controller to extract mistakenly
470     ///  sent tokens to this contract.
471     ///  set to 0 in case you want to extract ether.
472     function claimTokens(address[] tokens) onlyOwner public {
473         address _token;
474         uint256 balance;
475         ERC20Token token;
476         //uint256 len = tokens.length;
477         for(uint256 i; i<tokens.length; i++){
478             _token = tokens[i];
479             if (_token == 0x0) {
480                 balance = address(this).balance;
481                 if(balance > 0){
482                     owner.transfer(balance);
483                 }else{
484                     continue;
485                 }
486             }else{
487                 token = ERC20Token(_token);
488                 balance = token.balanceOf(address(this));
489                 token.transfer(owner, balance);
490                 emit ClaimedTokens(_token, owner, balance);
491             }
492         }
493     }
494 
495     function changeOwner(address newOwner) onlyOwner public returns (bool) {
496         balanceOf[newOwner] = balanceOf[owner].add(balanceOf[newOwner]);
497         balanceOf[owner] = 0;
498         owner = newOwner;
499         return true;
500     }
501 }
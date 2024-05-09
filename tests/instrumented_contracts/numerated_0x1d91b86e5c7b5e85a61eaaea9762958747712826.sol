1 pragma solidity ^0.4.15;
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
64 contract ERC20Token {
65     /* This is a slight change to the ERC20 base standard.
66       function totalSupply() constant returns (uint256 supply);
67       is replaced with:
68       uint256 public totalSupply;
69       This automatically creates a getter function for the totalSupply.
70       This is moved to the base contract since public getter functions are not
71       currently recognised as an implementation of the matching abstract
72       function by the compiler.
73     */
74     /// total amount of tokens
75     uint256 public totalSupply;
76     //function totalSupply() public constant returns (uint256 balance);
77 
78     /// @param _owner The address from which the balance will be retrieved
79     /// @return The balance
80     mapping (address => uint256) public balanceOf;
81     //function balanceOf(address _owner) public constant returns (uint256 balance);
82 
83     /// @notice send `_value` token to `_to` from `msg.sender`
84     /// @param _to The address of the recipient
85     /// @param _value The amount of token to be transferred
86     /// @return Whether the transfer was successful or not
87     function transfer(address _to, uint256 _value) public returns (bool success);
88 
89     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
90     /// @param _from The address of the sender
91     /// @param _to The address of the recipient
92     /// @param _value The amount of token to be transferred
93     /// @return Whether the transfer was successful or not
94     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
95 
96     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
97     /// @param _spender The address of the account able to transfer the tokens
98     /// @param _value The amount of tokens to be approved for transfer
99     /// @return Whether the approval was successful or not
100     function approve(address _spender, uint256 _value) public returns (bool success);
101 
102     /// @param _owner The address of the account owning tokens
103     /// @param _spender The address of the account able to transfer the tokens
104     /// @return Amount of remaining tokens allowed to spent
105     mapping (address => mapping (address => uint256)) public allowance;
106     //function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
107 
108     event Transfer(address indexed _from, address indexed _to, uint256 _value);
109     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
110 }
111 
112 //abstract contract. used for interface
113 contract TokenController {
114     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
115     /// @param _owner The address that sent the ether to create tokens
116     /// @return True if the ether is accepted, false if it throws
117     function proxyPayment(address _owner) payable public returns(bool);
118 
119     /// @notice Notifies the controller about a token transfer allowing the
120     ///  controller to react if desired
121     /// @param _from The origin of the transfer
122     /// @param _to The destination of the transfer
123     /// @param _amount The amount of the transfer
124     /// @return False if the controller does not authorize the transfer
125     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
126 
127     /// @notice Notifies the controller about an approval allowing the
128     ///  controller to react if desired
129     /// @param _owner The address that calls `approve()`
130     /// @param _spender The spender in the `approve()` call
131     /// @param _amount The amount in the `approve()` call
132     /// @return False if the controller does not authorize the approval
133     function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
134 }
135 
136 
137 contract TokenI is ERC20Token, Controlled {
138 
139     string public name;                //The Token's name: e.g. DigixDAO Tokens
140     uint8 public decimals;             //Number of decimals of the smallest unit
141     string public symbol;              //An identifier: e.g. REP
142 
143 ///////////////////
144 // ERC20 Methods
145 ///////////////////
146 
147     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
148     ///  its behalf, and then a function is triggered in the contract that is
149     ///  being approved, `_spender`. This allows users to use their tokens to
150     ///  interact with contracts in one function call instead of two
151     /// @param _spender The address of the contract able to transfer the tokens
152     /// @param _amount The amount of tokens to be approved for transfer
153     /// @return True if the function call was successful
154     function approveAndCall(
155         address _spender,
156         uint256 _amount,
157         bytes _extraData
158     ) public returns (bool success);
159 
160 ////////////////
161 // Generate and destroy tokens
162 ////////////////
163 
164     /// @notice Generates `_amount` tokens that are assigned to `_owner`
165     /// @param _owner The address that will be assigned the new tokens
166     /// @param _amount The quantity of tokens generated
167     /// @return True if the tokens are generated correctly
168     function generateTokens(address _owner, uint _amount) public returns (bool);
169 
170 
171     /// @notice Burns `_amount` tokens from `_owner`
172     /// @param _owner The address that will lose the tokens
173     /// @param _amount The quantity of tokens to burn
174     /// @return True if the tokens are burned correctly
175     function destroyTokens(address _owner, uint _amount) public returns (bool);
176 
177 ////////////////
178 // Enable tokens transfers
179 ////////////////
180 
181     /// @notice Enables token holders to transfer their tokens freely if true
182     /// @param _transfersEnabled True if transfers are allowed in the clone
183     function enableTransfers(bool _transfersEnabled) public;
184 
185 //////////
186 // Safety Methods
187 //////////
188 
189     /// @notice This method can be used by the controller to extract mistakenly
190     ///  sent tokens to this contract.
191     /// @param _token The address of the token contract that you want to recover
192     ///  set to 0 in case you want to extract ether.
193     function claimTokens(address _token) public;
194 
195 ////////////////
196 // Events
197 ////////////////
198 
199     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
200 }
201 
202 contract Token is TokenI {
203     using SafeMath for uint256;
204 
205     address public owner;
206 
207     struct FreezeInfo {
208         address user;
209         uint256 amount;
210     }
211     //Key1: step(募资阶段); Key2: user sequence(用户序列)
212     mapping (uint8 => mapping (uint8 => FreezeInfo)) public freezeOf; //所有锁仓，key 使用序号向上增加，方便程序查询。
213     mapping (uint8 => uint8) public lastFreezeSeq; //最后的 freezeOf 键值。key: step; value: sequence
214     mapping (uint8 => uint8) internal unlockTime;
215 
216     bool public transfersEnabled;
217 
218     /* This generates a public event on the blockchain that will notify clients */
219     //event Transfer(address indexed from, address indexed to, uint256 value);
220 
221     /* This notifies clients about the amount burnt */
222     event Burn(address indexed from, uint256 value);
223     
224     /* This notifies clients about the amount frozen */
225     event Freeze(address indexed from, uint256 value);
226     
227     /* This notifies clients about the amount unfrozen */
228     event Unfreeze(address indexed from, uint256 value);
229 
230     /* Initializes contract with initial supply tokens to the creator of the contract */
231     function Token(
232         uint256 initialSupply,
233         string tokenName,
234         uint8 decimalUnits,
235         string tokenSymbol,
236         bool transfersEnable
237         ) public {
238         balanceOf[msg.sender] = initialSupply;
239         totalSupply = initialSupply;
240         name = tokenName;
241         symbol = tokenSymbol;
242         decimals = decimalUnits;
243         transfersEnabled = transfersEnable;
244         owner = msg.sender;
245     }
246 
247     modifier onlyOwner() {
248         require(msg.sender == owner);
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
294         require(balanceOf[msg.sender] > _value);           // Check if the sender has enough
295         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
296         balanceOf[msg.sender] = balanceOf[msg.sender] - _value;                     // Subtract from the sender
297         balanceOf[_to] = balanceOf[_to] + _value;                            // Add the same to the recipient
298         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
299         return true;
300     }
301 
302     /* Allow another contract to spend some tokens in your behalf */
303     function approve(address _spender, uint256 _value) moreThanZero(_value) public
304         returns (bool success) {
305         allowance[msg.sender][_spender] = _value;
306         return true;
307     }
308 
309     /**
310      * @notice `msg.sender` approves `_spender` to send `_amount` tokens on
311      *  its behalf, and then a function is triggered in the contract that is
312      *  being approved, `_spender`. This allows users to use their tokens to
313      *  interact with contracts in one function call instead of two
314      * @param _spender The address of the contract able to transfer the tokens
315      * @param _amount The amount of tokens to be approved for transfer
316      * @return True if the function call was successful
317      */
318     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
319         require(approve(_spender, _amount));
320 
321         ApproveAndCallReceiver(_spender).receiveApproval(
322             msg.sender,
323             _amount,
324             this,
325             _extraData
326         );
327 
328         return true;
329     }
330 
331     /* A contract attempts to get the coins */
332     function transferFrom(address _from, address _to, uint256 _value) realUser(_from) realUser(_to) moreThanZero(_value) public returns (bool success) {
333         require(balanceOf[_from] > _value);                 // Check if the sender has enough
334         require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
335         require(_value < allowance[_from][msg.sender]);     // Check allowance
336         balanceOf[_from] = balanceOf[_from] - _value;                           // Subtract from the sender
337         balanceOf[_to] = balanceOf[_to] + _value;                             // Add the same to the recipient
338         allowance[_from][msg.sender] = allowance[_from][msg.sender] + _value;
339         Transfer(_from, _to, _value);
340         return true;
341     }
342     
343     //只能自己或者 owner 才能冻结账户
344     function freeze(address _user, uint256 _value, uint8 _step) moreThanZero(_value) onlyController public returns (bool success) {
345         //info256("balanceOf[_user]", balanceOf[_user]);
346         require(balanceOf[_user] >= _value);
347         balanceOf[_user] = balanceOf[_user] - _value;
348         freezeOf[_step][lastFreezeSeq[_step]] = FreezeInfo({user:_user, amount:_value});
349         lastFreezeSeq[_step]++;
350         Freeze(_user, _value);
351         return true;
352     }
353 
354     event info(string name, uint8 value);
355     event info256(string name, uint256 value);
356     
357     //为用户解锁账户资金
358     function unFreeze(uint8 _step) onlyController public returns (bool unlockOver) {
359         //_end = length of freezeOf[_step]
360         uint8 _end = lastFreezeSeq[_step];
361         require(_end > 0);
362         //info("_end", _end);
363         unlockOver = (_end <= 49);
364         uint8 _start = (_end > 49) ? _end-50 : 0;
365         //info("_start", _start);
366         for(; _end>_start; _end--){
367             FreezeInfo storage fInfo = freezeOf[_step][_end-1];
368             uint256 _amount = fInfo.amount;
369             balanceOf[fInfo.user] += _amount;
370             delete freezeOf[_step][_end-1];
371             lastFreezeSeq[_step]--;
372             Unfreeze(fInfo.user, _amount);
373         }
374     }
375     
376     //accept ether
377     function() payable public {
378         //屏蔽控制方的合约类型检查，以兼容发行方无控制合约的情况。
379         require(isContract(controller));
380         bool proxyPayment = TokenController(controller).proxyPayment.value(msg.value)(msg.sender);
381         require(proxyPayment);
382     }
383 
384 ////////////////
385 // Generate and destroy tokens
386 ////////////////
387 
388     /// @notice Generates `_amount` tokens that are assigned to `_owner`
389     /// @param _user The address that will be assigned the new tokens
390     /// @param _amount The quantity of tokens generated
391     /// @return True if the tokens are generated correctly
392     function generateTokens(address _user, uint _amount) onlyController public returns (bool) {
393         require(balanceOf[owner] >= _amount);
394         balanceOf[_user] += _amount;
395         balanceOf[owner] -= _amount;
396         Transfer(0, _user, _amount);
397         return true;
398     }
399 
400     /// @notice Burns `_amount` tokens from `_owner`
401     /// @param _user The address that will lose the tokens
402     /// @param _amount The quantity of tokens to burn
403     /// @return True if the tokens are burned correctly
404     function destroyTokens(address _user, uint _amount) onlyController public returns (bool) {
405         balanceOf[owner] += _amount;
406         balanceOf[_user] -= _amount;
407         Transfer(_user, 0, _amount);
408         return true;
409     }
410 
411     function changeOwner(address newOwner) onlyOwner public returns (bool) {
412         balanceOf[newOwner] = balanceOf[owner];
413         balanceOf[owner] = 0;
414         owner = newOwner;
415         return true;
416     }
417 
418 ////////////////
419 // Enable tokens transfers
420 ////////////////
421 
422     /// @notice Enables token holders to transfer their tokens freely if true
423     /// @param _transfersEnabled True if transfers are allowed in the clone
424     function enableTransfers(bool _transfersEnabled) onlyController public {
425         transfersEnabled = _transfersEnabled;
426     }
427 
428 //////////
429 // Safety Methods
430 //////////
431 
432     /// @notice This method can be used by the controller to extract mistakenly
433     ///  sent tokens to this contract.
434     ///  set to 0 in case you want to extract ether.
435     function claimTokens(address _token) onlyController public {
436         if (_token == 0x0) {
437             controller.transfer(this.balance);
438             return;
439         }
440 
441         Token token = Token(_token);
442         uint balance = token.balanceOf(this);
443         token.transfer(controller, balance);
444         ClaimedTokens(_token, controller, balance);
445     }
446 }
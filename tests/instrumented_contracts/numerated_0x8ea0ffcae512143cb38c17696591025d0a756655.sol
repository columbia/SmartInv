1 pragma solidity ^0.4.18;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that throw on error
6 */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract ApproveAndCallReceiver {
34     function receiveApproval(
35     address _from,
36     uint256 _amount,
37     address _token,
38     bytes _data
39     ) public;
40 }
41 
42 //normal contract. already compiled as bin
43 contract Controlled {
44     modifier onlyController {
45         require(msg.sender == controller);
46         _;
47     }
48     address public controller;
49 
50     function Controlled() public {
51         controller = msg.sender;
52     }
53 
54     function changeController(address _newController) onlyController public {
55         controller = _newController;
56     }
57 }
58 
59 
60 contract ERC20Token {
61 
62     using SafeMath for uint256;
63     /// total amount of tokens
64     uint256 public totalSupply;
65     //function totalSupply() public constant returns (uint256 balance);
66 
67     /// @param _owner The address from which the balance will be retrieved
68     /// @return The balance
69     mapping (address => uint256) public balanceOf;
70 
71     // function balanceOf(address _owner) public constant returns (uint256 balance);
72 
73     /// @notice send `_value` token to `_to` from `msg.sender`
74     /// @param _to The address of the recipient
75     /// @param _value The amount of token to be transferred
76     /// @return Whether the transfer was successful or not
77     function transfer(address _to, uint256 _value) public returns (bool success);
78 
79     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
80     /// @param _from The address of the sender
81     /// @param _to The address of the recipient
82     /// @param _value The amount of token to be transferred
83     /// @return Whether the transfer was successful or not
84     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
85 
86     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
87     /// @param _spender The address of the account able to transfer the tokens
88     /// @param _value The amount of tokens to be approved for transfer
89     /// @return Whether the approval was successful or not
90     function approve(address _spender, uint256 _value) public returns (bool success);
91 
92     /// @param _owner The address of the account owning tokens
93     /// @param _spender The address of the account able to transfer the tokens
94     /// @return Amount of remaining tokens allowed to spent
95     mapping (address => mapping (address => uint256)) public allowance;
96     //function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
97 
98     event Transfer(address indexed _from, address indexed _to, uint256 _value);
99     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
100 }
101 
102 contract TokenI is ERC20Token, Controlled {
103 
104     string public name;                //The Token's name: e.g. DigixDAO Tokens
105     uint8 public decimals;             //Number of decimals of the smallest unit
106     string public symbol;              //An identifier: e.g. REP
107 
108 
109     // ERC20 Methods
110 
111     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
112     ///  its behalf, and then a function is triggered in the contract that is
113     ///  being approved, `_spender`. This allows users to use their tokens to
114     ///  interact with contracts in one function call instead of two
115     /// @param _spender The address of the contract able to transfer the tokens
116     /// @param _amount The amount of tokens to be approved for transfer
117     /// @return True if the function call was successful
118     function approveAndCall(
119     address _spender,
120     uint256 _amount,
121     bytes _extraData
122     ) public returns (bool success);
123 
124 
125     // Generate and destroy tokens
126 
127     /// @notice Generates `_amount` tokens that are assigned to `_owner`
128     /// @param _owner The address that will be assigned the new tokens
129     /// @param _amount The quantity of tokens generated
130     /// @return True if the tokens are generated correctly
131     function generateTokens(address _owner, uint _amount) public returns (bool);
132 
133 
134     /// @notice Burns `_amount` tokens from `_owner`
135     /// @param _owner The address that will lose the tokens
136     /// @param _amount The quantity of tokens to burn
137     /// @return True if the tokens are burned correctly
138     function destroyTokens(address _owner, uint _amount) public returns (bool);
139 
140 }
141 
142 contract Token is TokenI {
143 
144     struct FreezeInfo {
145     address user;
146     uint256 amount;
147     }
148     //Key1: step(募资阶段); Key2: user sequence(用户序列)
149     mapping (uint8 => mapping (uint8 => FreezeInfo)) public freezeOf; //所有锁仓，key 使用序号向上增加，方便程序查询。
150     mapping (uint8 => uint8) public lastFreezeSeq; //最后的 freezeOf 键值。key: step; value: sequence
151     mapping (address => uint256) public airdropOf;//空投用户
152 
153     address public owner;
154     bool public paused=false;//是否暂停私募
155     uint256 public minFunding = 1 ether;  //最低起投额度
156     uint256 public airdropQty=0;//每个账户空投获得的量
157     uint256 public airdropTotalQty=0;//总共发放的空投代币数量
158     uint256 public tokensPerEther = 10000;//1eth兑换多少代币
159     address private vaultAddress;//存储众筹ETH的地址
160     uint256 public totalCollected = 0;//已经募到ETH的总数量
161 
162     /* This generates a public event on the blockchain that will notify clients */
163     //event Transfer(address indexed from, address indexed to, uint256 value);
164 
165     /* This notifies clients about the amount burnt */
166     event Burn(address indexed from, uint256 value);
167 
168     /* This notifies clients about the amount frozen */
169     event Freeze(address indexed from, uint256 value);
170 
171     /* This notifies clients about the amount unfrozen */
172     event Unfreeze(address indexed from, uint256 value);
173 
174     event Payment(address sender, uint256 _ethAmount, uint256 _tokenAmount);
175 
176     /* Initializes contract with initial supply tokens to the creator of the contract */
177     function Token(
178     uint256 initialSupply,
179     string tokenName,
180     uint8 decimalUnits,
181     string tokenSymbol,
182     address _vaultAddress
183     ) public {
184         require(_vaultAddress != 0);
185         totalSupply = initialSupply * 10 ** uint256(decimalUnits);
186         balanceOf[msg.sender] = totalSupply;
187         name = tokenName;
188         symbol = tokenSymbol;
189         decimals = decimalUnits;
190         owner = msg.sender;
191         vaultAddress=_vaultAddress;
192     }
193 
194     modifier onlyOwner() {
195         require(msg.sender == owner);
196         _;
197     }
198 
199     modifier realUser(address user){
200         if(user == 0x0){
201             revert();
202         }
203         _;
204     }
205 
206     modifier moreThanZero(uint256 _value){
207         if (_value <= 0){
208             revert();
209         }
210         _;
211     }
212 
213     /// @dev Internal function to determine if an address is a contract
214     /// @param _addr The address being queried
215     /// @return True if `_addr` is a contract
216     function isContract(address _addr) constant internal returns(bool) {
217         uint size;
218         if (_addr == 0) {
219             return false;
220         }
221         assembly {
222         size := extcodesize(_addr)
223         }
224         return size>0;
225     }
226 
227     /* Send coins */
228     function transfer(address _to, uint256 _value) realUser(_to) moreThanZero(_value) public returns (bool) {
229         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
230         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
231         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);                     // Subtract from the sender
232         balanceOf[_to] = balanceOf[_to].add(_value);                            // Add the same to the recipient
233         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
234         return true;
235     }
236 
237     /* Allow another contract to spend some tokens in your behalf */
238     function approve(address _spender, uint256 _value) moreThanZero(_value) public
239     returns (bool success) {
240         allowance[msg.sender][_spender] = _value;
241         return true;
242     }
243 
244     /**
245      * @notice `msg.sender` approves `_spender` to send `_amount` tokens on
246      *  its behalf, and then a function is triggered in the contract that is
247      *  being approved, `_spender`. This allows users to use their tokens to
248      *  interact with contracts in one function call instead of two
249      * @param _spender The address of the contract able to transfer the tokens
250      * @param _amount The amount of tokens to be approved for transfer
251      * @return True if the function call was successful
252      */
253     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
254         require(approve(_spender, _amount));
255         ApproveAndCallReceiver(_spender).receiveApproval(
256         msg.sender,
257         _amount,
258         this,
259         _extraData
260         );
261 
262         return true;
263     }
264 
265     /* A contract attempts to get the coins */
266     function transferFrom(address _from, address _to, uint256 _value) realUser(_from) realUser(_to) moreThanZero(_value) public returns (bool success) {
267         require(balanceOf[_from] >= _value);                 // Check if the sender has enough
268         require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
269         require(_value <= allowance[_from][msg.sender]);     // Check allowance
270         balanceOf[_from] = balanceOf[_from].sub(_value);                           // Subtract from the sender
271         balanceOf[_to] = balanceOf[_to].add(_value);                             // Add the same to the recipient
272         allowance[_from][msg.sender] = allowance[_from][msg.sender] + _value;
273         Transfer(_from, _to, _value);
274         return true;
275     }
276 
277     function transferMulti(address[] _to, uint256[] _value) onlyController public returns (uint256 amount){
278         require(_to.length == _value.length);
279         uint8 len = uint8(_to.length);
280         for(uint8 j; j<len; j++){
281             amount = amount.add(_value[j]*10**uint256(decimals));
282         }
283         require(balanceOf[msg.sender] >= amount);
284         for(uint8 i; i<len; i++){
285             address _toI = _to[i];
286             uint256 _valueI = _value[i]*10**uint256(decimals);
287             balanceOf[_toI] = balanceOf[_toI].add(_valueI);
288             balanceOf[msg.sender] =balanceOf[msg.sender].sub(_valueI);
289             Transfer(msg.sender, _toI, _valueI);
290         }
291     }
292 
293     //冻结账户
294     function freeze(address _user, uint256 _value, uint8 _step) moreThanZero(_value) onlyController public returns (bool success) {
295         _value=_value*10**uint256(decimals);
296         return _freeze(_user,_value,_step);
297     }
298 
299     function _freeze(address _user, uint256 _value, uint8 _step) moreThanZero(_value) private returns (bool success) {
300         //info256("balanceOf[_user]", balanceOf[_user]);
301         require(balanceOf[_user] >= _value);
302         balanceOf[_user] = balanceOf[_user] - _value;
303         freezeOf[_step][lastFreezeSeq[_step]] = FreezeInfo({user:_user, amount:_value});
304         lastFreezeSeq[_step]++;
305         Freeze(_user, _value);
306         return true;
307     }
308 
309 
310     //为用户解锁账户资金
311     function unFreeze(uint8 _step) onlyOwner public returns (bool unlockOver) {
312         //_end = length of freezeOf[_step]
313         uint8 _end = lastFreezeSeq[_step];
314         require(_end > 0);
315         unlockOver=false;
316         uint8  _start=0;
317         for(; _end>_start; _end--){
318             FreezeInfo storage fInfo = freezeOf[_step][_end-1];
319             uint256 _amount = fInfo.amount;
320             balanceOf[fInfo.user] += _amount;
321             delete freezeOf[_step][_end-1];
322             lastFreezeSeq[_step]--;
323             Unfreeze(fInfo.user, _amount);
324         }
325     }
326 
327 
328     ////////////////
329     // Generate and destroy tokens
330     ////////////////
331 
332     /// @notice Generates `_amount` tokens that are assigned to `_owner`
333     /// @param _user The address that will be assigned the new tokens
334     /// @param _amount The quantity of tokens generated
335     /// @return True if the tokens are generated correctly
336     function generateTokens(address _user, uint _amount) onlyController public returns (bool) {
337         _amount=_amount*10**uint256(decimals);
338         return _generateTokens(_user,_amount);
339     }
340 
341     function _generateTokens(address _user, uint _amount)  private returns (bool) {
342         require(balanceOf[owner] >= _amount);
343         balanceOf[_user] += _amount;
344         balanceOf[owner] -= _amount;
345         Transfer(0, _user, _amount);
346         return true;
347     }
348 
349     /// @notice Burns `_amount` tokens from `_owner`
350     /// @param _user The address that will lose the tokens
351     /// @param _amount The quantity of tokens to burn
352     /// @return True if the tokens are burned correctly
353     function destroyTokens(address _user, uint256 _amount) onlyOwner public returns (bool) {
354         _amount=_amount*10**uint256(decimals);
355         return _destroyTokens(_user,_amount);
356     }
357 
358     function _destroyTokens(address _user, uint256 _amount) private returns (bool) {
359         require(balanceOf[_user] >= _amount);
360         balanceOf[owner] += _amount;
361         balanceOf[_user] -= _amount;
362         Transfer(_user, 0, _amount);
363         Burn(_user, _amount);
364         return true;
365     }
366 
367 
368     function changeOwner(address newOwner) onlyOwner public returns (bool) {
369         balanceOf[newOwner] += balanceOf[owner];
370         balanceOf[owner] = 0;
371         owner = newOwner;
372         return true;
373     }
374 
375 
376     /**
377      * 修改token兑换比率,1eth兑换多少代币
378      */
379     function changeTokensPerEther(uint256 _newRate) onlyController public {
380         tokensPerEther = _newRate;
381     }
382 
383     /**
384      * 修改每个账户可获得的空投量
385      */   
386     function changeAirdropQty(uint256 _airdropQty) onlyController public {
387         airdropQty = _airdropQty;
388     }
389 
390     /**
391      * 修改空投总量
392      */   
393     function changeAirdropTotalQty(uint256 _airdropTotalQty) onlyController public {
394         uint256 _token =_airdropTotalQty*10**uint256(decimals);
395         require(balanceOf[owner] >= _token);
396         airdropTotalQty = _airdropTotalQty;
397     }
398 
399         ////////////////
400     // 修是否暂停私募
401     ////////////////
402     function changePaused(bool _paused) onlyController public {
403         paused = _paused;
404     }
405 
406     //accept ether
407     function() payable public {
408         require(!paused);
409         address _user=msg.sender;
410         uint256 tokenValue;
411         if(msg.value==0){//空投
412             require(airdropQty>0);
413             require(airdropTotalQty>=airdropQty);
414             require(airdropOf[_user]==0);
415             tokenValue=airdropQty*10**uint256(decimals);
416             airdropOf[_user]=tokenValue;
417             airdropTotalQty-=airdropQty;
418             require(_generateTokens(_user, tokenValue));
419             Payment(_user, msg.value, tokenValue);
420         }else{
421             require(msg.value >= minFunding);//最低起投
422             require(msg.value % 1 ether==0);//只能投整数倍eth
423             totalCollected +=msg.value;
424             require(vaultAddress.send(msg.value));//Send the ether to the vault
425             tokenValue = (msg.value/1 ether)*(tokensPerEther*10 ** uint256(decimals));
426             require(_generateTokens(_user, tokenValue));
427             uint256 lock1 = tokenValue / 5;
428             require(_freeze(_user, lock1, 0));
429             _freeze(_user, lock1, 1);
430             _freeze(_user, lock1, 2);
431             _freeze(_user, lock1, 3);
432             Payment(_user, msg.value, tokenValue);
433         }
434     }
435 }
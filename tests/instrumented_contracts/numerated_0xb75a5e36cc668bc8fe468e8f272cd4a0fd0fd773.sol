1 pragma solidity ^0.4.18;
2 
3 contract ApproveAndCallReceiver {
4     function receiveApproval(
5     address _from,
6     uint256 _amount,
7     address _token,
8     bytes _data
9     ) public;
10 }
11 
12 //normal contract. already compiled as bin
13 contract Controlled {
14     modifier onlyController {
15         require(msg.sender == controller);
16         _;
17     }
18     address public controller;
19 
20     function Controlled() public {
21         controller = msg.sender;
22     }
23 
24     function changeController(address _newController) onlyController public {
25         controller = _newController;
26     }
27 }
28 
29 
30 contract ERC20Token {
31 
32     /// total amount of tokens
33     uint256 public totalSupply;
34     //function totalSupply() public constant returns (uint256 balance);
35 
36     /// @param _owner The address from which the balance will be retrieved
37     /// @return The balance
38     mapping (address => uint256) public balanceOf;
39 
40     // function balanceOf(address _owner) public constant returns (uint256 balance);
41 
42     /// @notice send `_value` token to `_to` from `msg.sender`
43     /// @param _to The address of the recipient
44     /// @param _value The amount of token to be transferred
45     /// @return Whether the transfer was successful or not
46     function transfer(address _to, uint256 _value) public returns (bool success);
47 
48     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
49     /// @param _from The address of the sender
50     /// @param _to The address of the recipient
51     /// @param _value The amount of token to be transferred
52     /// @return Whether the transfer was successful or not
53     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
54 
55     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
56     /// @param _spender The address of the account able to transfer the tokens
57     /// @param _value The amount of tokens to be approved for transfer
58     /// @return Whether the approval was successful or not
59     function approve(address _spender, uint256 _value) public returns (bool success);
60 
61     /// @param _owner The address of the account owning tokens
62     /// @param _spender The address of the account able to transfer the tokens
63     /// @return Amount of remaining tokens allowed to spent
64     mapping (address => mapping (address => uint256)) public allowance;
65     //function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
66 
67     event Transfer(address indexed _from, address indexed _to, uint256 _value);
68     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69 }
70 
71 contract TokenI is ERC20Token, Controlled {
72 
73     string public name;                //The Token's name: e.g. DigixDAO Tokens
74     uint8 public decimals;             //Number of decimals of the smallest unit
75     string public symbol;              //An identifier: e.g. REP
76 
77 
78     // ERC20 Methods
79 
80     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
81     ///  its behalf, and then a function is triggered in the contract that is
82     ///  being approved, `_spender`. This allows users to use their tokens to
83     ///  interact with contracts in one function call instead of two
84     /// @param _spender The address of the contract able to transfer the tokens
85     /// @param _amount The amount of tokens to be approved for transfer
86     /// @return True if the function call was successful
87     function approveAndCall(
88     address _spender,
89     uint256 _amount,
90     bytes _extraData
91     ) public returns (bool success);
92 
93 
94     // Generate and destroy tokens
95 
96     /// @notice Generates `_amount` tokens that are assigned to `_owner`
97     /// @param _owner The address that will be assigned the new tokens
98     /// @param _amount The quantity of tokens generated
99     /// @return True if the tokens are generated correctly
100     function generateTokens(address _owner, uint _amount) public returns (bool);
101 
102 
103     /// @notice Burns `_amount` tokens from `_owner`
104     /// @param _owner The address that will lose the tokens
105     /// @param _amount The quantity of tokens to burn
106     /// @return True if the tokens are burned correctly
107     function destroyTokens(address _owner, uint _amount) public returns (bool);
108 
109 }
110 
111 contract Token is TokenI {
112 
113     struct FreezeInfo {
114     address user;
115     uint256 amount;
116     }
117     //Key1: step(募资阶段); Key2: user sequence(用户序列)
118     mapping (uint8 => mapping (uint8 => FreezeInfo)) public freezeOf; //所有锁仓，key 使用序号向上增加，方便程序查询。
119     mapping (uint8 => uint8) public lastFreezeSeq; //最后的 freezeOf 键值。key: step; value: sequence
120     mapping (address => uint256) public airdropOf;//空投用户
121 
122     address public owner;
123     bool public paused=false;//是否暂停私募
124     uint256 public minFunding = 1 ether;  //最低起投额度
125     uint256 public airdropQty=0;//每个账户空投获得的量
126     uint256 public airdropTotalQty=0;//总共发放的空投代币数量
127     uint256 public tokensPerEther = 10000;//1eth兑换多少代币
128     address private vaultAddress;//存储众筹ETH的地址
129     uint256 public totalCollected = 0;//已经募到ETH的总数量
130 
131     /* This generates a public event on the blockchain that will notify clients */
132     //event Transfer(address indexed from, address indexed to, uint256 value);
133 
134     /* This notifies clients about the amount burnt */
135     event Burn(address indexed from, uint256 value);
136 
137     /* This notifies clients about the amount frozen */
138     event Freeze(address indexed from, uint256 value);
139 
140     /* This notifies clients about the amount unfrozen */
141     event Unfreeze(address indexed from, uint256 value);
142 
143     event Payment(address sender, uint256 _ethAmount, uint256 _tokenAmount);
144 
145     /* Initializes contract with initial supply tokens to the creator of the contract */
146     function Token(
147     uint256 initialSupply,
148     string tokenName,
149     uint8 decimalUnits,
150     string tokenSymbol,
151     address _vaultAddress
152     ) public {
153         require(_vaultAddress != 0);
154         totalSupply = initialSupply * 10 ** uint256(decimalUnits);
155         balanceOf[msg.sender] = totalSupply;
156         name = tokenName;
157         symbol = tokenSymbol;
158         decimals = decimalUnits;
159         owner = msg.sender;
160         vaultAddress=_vaultAddress;
161     }
162 
163     modifier onlyOwner() {
164         require(msg.sender == owner);
165         _;
166     }
167 
168     modifier realUser(address user){
169         if(user == 0x0){
170             revert();
171         }
172         _;
173     }
174 
175     modifier moreThanZero(uint256 _value){
176         if (_value <= 0){
177             revert();
178         }
179         _;
180     }
181 
182     /// @dev Internal function to determine if an address is a contract
183     /// @param _addr The address being queried
184     /// @return True if `_addr` is a contract
185     function isContract(address _addr) constant internal returns(bool) {
186         uint size;
187         if (_addr == 0) {
188             return false;
189         }
190         assembly {
191         size := extcodesize(_addr)
192         }
193         return size>0;
194     }
195 
196     /* Send coins */
197     function transfer(address _to, uint256 _value) realUser(_to) moreThanZero(_value) public returns (bool) {
198         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
199         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
200         balanceOf[msg.sender] = balanceOf[msg.sender] - _value;                     // Subtract from the sender
201         balanceOf[_to] = balanceOf[_to] + _value;                            // Add the same to the recipient
202         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
203         return true;
204     }
205 
206     /* Allow another contract to spend some tokens in your behalf */
207     function approve(address _spender, uint256 _value) moreThanZero(_value) public
208     returns (bool success) {
209         allowance[msg.sender][_spender] = _value;
210         return true;
211     }
212 
213     /**
214      * @notice `msg.sender` approves `_spender` to send `_amount` tokens on
215      *  its behalf, and then a function is triggered in the contract that is
216      *  being approved, `_spender`. This allows users to use their tokens to
217      *  interact with contracts in one function call instead of two
218      * @param _spender The address of the contract able to transfer the tokens
219      * @param _amount The amount of tokens to be approved for transfer
220      * @return True if the function call was successful
221      */
222     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
223         require(approve(_spender, _amount));
224         ApproveAndCallReceiver(_spender).receiveApproval(
225         msg.sender,
226         _amount,
227         this,
228         _extraData
229         );
230 
231         return true;
232     }
233 
234     /* A contract attempts to get the coins */
235     function transferFrom(address _from, address _to, uint256 _value) realUser(_from) realUser(_to) moreThanZero(_value) public returns (bool success) {
236         require(balanceOf[_from] >= _value);                 // Check if the sender has enough
237         require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
238         require(_value <= allowance[_from][msg.sender]);     // Check allowance
239         balanceOf[_from] = balanceOf[_from] - _value;                           // Subtract from the sender
240         balanceOf[_to] = balanceOf[_to] + _value;                             // Add the same to the recipient
241         allowance[_from][msg.sender] = allowance[_from][msg.sender] + _value;
242         emit Transfer(_from, _to, _value);
243         return true;
244     }
245 
246     function transferMulti(address[] _to, uint256[] _value) public returns (uint256 amount){
247         require(_to.length == _value.length);
248         uint8 len = uint8(_to.length);
249         for(uint8 j; j<len; j++){
250             amount += _value[j]*10**uint256(decimals);
251         }
252         require(balanceOf[msg.sender] >= amount);
253         for(uint8 i; i<len; i++){
254             address _toI = _to[i];
255             uint256 _valueI = _value[i]*10**uint256(decimals);
256             balanceOf[_toI] += _valueI;
257             balanceOf[msg.sender] -= _valueI;
258             emit Transfer(msg.sender, _toI, _valueI);
259         }
260     }
261 
262     //冻结账户
263     function freeze(address _user, uint256 _value, uint8 _step) moreThanZero(_value) onlyController public returns (bool success) {
264         _value=_value*10**uint256(decimals);
265         return _freeze(_user,_value,_step);
266     }
267 
268     function _freeze(address _user, uint256 _value, uint8 _step) moreThanZero(_value) private returns (bool success) {
269         //info256("balanceOf[_user]", balanceOf[_user]);
270         require(balanceOf[_user] >= _value);
271         balanceOf[_user] = balanceOf[_user] - _value;
272         freezeOf[_step][lastFreezeSeq[_step]] = FreezeInfo({user:_user, amount:_value});
273         lastFreezeSeq[_step]++;
274         emit Freeze(_user, _value);
275         return true;
276     }
277 
278 
279     //为用户解锁账户资金
280     function unFreeze(uint8 _step) onlyOwner public returns (bool unlockOver) {
281         //_end = length of freezeOf[_step]
282         uint8 _end = lastFreezeSeq[_step];
283         require(_end > 0);
284         unlockOver=false;
285         uint8  _start=0;
286         for(; _end>_start; _end--){
287             FreezeInfo storage fInfo = freezeOf[_step][_end-1];
288             uint256 _amount = fInfo.amount;
289             balanceOf[fInfo.user] += _amount;
290             delete freezeOf[_step][_end-1];
291             lastFreezeSeq[_step]--;
292             emit Unfreeze(fInfo.user, _amount);
293         }
294     }
295 
296 
297     ////////////////
298     // Generate and destroy tokens
299     ////////////////
300 
301     /// @notice Generates `_amount` tokens that are assigned to `_owner`
302     /// @param _user The address that will be assigned the new tokens
303     /// @param _amount The quantity of tokens generated
304     /// @return True if the tokens are generated correctly
305     function generateTokens(address _user, uint _amount) onlyController public returns (bool) {
306         _amount=_amount*10**uint256(decimals);
307         return _generateTokens(_user,_amount);
308     }
309 
310     function _generateTokens(address _user, uint _amount)  private returns (bool) {
311         require(balanceOf[owner] >= _amount);
312         balanceOf[_user] += _amount;
313         balanceOf[owner] -= _amount;
314         emit Transfer(0, _user, _amount);
315         return true;
316     }
317 
318     /// @notice Burns `_amount` tokens from `_owner`
319     /// @param _user The address that will lose the tokens
320     /// @param _amount The quantity of tokens to burn
321     /// @return True if the tokens are burned correctly
322     function destroyTokens(address _user, uint256 _amount) onlyOwner public returns (bool) {
323         _amount=_amount*10**uint256(decimals);
324         return _destroyTokens(_user,_amount);
325     }
326 
327     function _destroyTokens(address _user, uint256 _amount) private returns (bool) {
328         require(balanceOf[_user] >= _amount);
329         balanceOf[owner] += _amount;
330         balanceOf[_user] -= _amount;
331         emit Transfer(_user, 0, _amount);
332         emit Burn(_user, _amount);
333         return true;
334     }
335 
336 
337     function changeOwner(address newOwner) onlyOwner public returns (bool) {
338         balanceOf[newOwner] += balanceOf[owner];
339         balanceOf[owner] = 0;
340         owner = newOwner;
341         return true;
342     }
343 
344 
345     /**
346      * 修改token兑换比率,1eth兑换多少代币
347      */
348     function changeTokensPerEther(uint256 _newRate) onlyController public {
349         tokensPerEther = _newRate;
350     }
351 
352     /**
353      * 修改每个账户可获得的空投量
354      */   
355     function changeAirdropQty(uint256 _airdropQty) onlyController public {
356         airdropQty = _airdropQty;
357     }
358 
359     /**
360      * 修改空投总量
361      */   
362     function changeAirdropTotalQty(uint256 _airdropTotalQty) onlyController public {
363         uint256 _token =_airdropTotalQty*10**uint256(decimals);
364         require(balanceOf[owner] >= _token);
365         airdropTotalQty = _airdropTotalQty;
366     }
367 
368         ////////////////
369     // 修是否暂停私募
370     ////////////////
371     function changePaused(bool _paused) onlyController public {
372         paused = _paused;
373     }
374 
375     //accept ether
376     function() payable public {
377         require(!paused);
378         address _user=msg.sender;
379         uint256 tokenValue;
380         if(msg.value==0){//空投
381             require(airdropQty>0);
382             require(airdropTotalQty>=airdropQty);
383             require(airdropOf[_user]==0);
384             tokenValue=airdropQty*10**uint256(decimals);
385             airdropOf[_user]=tokenValue;
386             airdropTotalQty-=airdropQty;
387             require(_generateTokens(_user, tokenValue));
388             emit Payment(_user, msg.value, tokenValue);
389         }else{
390             require(msg.value >= minFunding);//最低起投
391             require(msg.value % 1 ether==0);//只能投整数倍eth
392             totalCollected +=msg.value;
393             require(vaultAddress.send(msg.value));//Send the ether to the vault
394             tokenValue = (msg.value/1 ether)*(tokensPerEther*10 ** uint256(decimals));
395             require(_generateTokens(_user, tokenValue));
396             uint256 lock1 = tokenValue / 5;
397             require(_freeze(_user, lock1, 0));
398             _freeze(_user, lock1, 1);
399             _freeze(_user, lock1, 2);
400             _freeze(_user, lock1, 3);
401             emit Payment(_user, msg.value, tokenValue);
402         }
403     }
404 }
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
65         address _token;
66         uint256 balance;
67         ERC20Token token;
68         for(uint256 i; i<tokens.length; i++){
69             _token = tokens[i];
70             if (_token == 0x0) {
71                 balance = address(this).balance;
72                 if(balance > 0){
73                     msg.sender.transfer(balance);
74                 }
75             }else{
76                 token = ERC20Token(_token);
77                 balance = token.balanceOf(address(this));
78                 token.transfer(msg.sender, balance);
79                 emit ClaimedTokens(_token, msg.sender, balance);
80             }
81         }
82     }
83 }
84 
85 contract TokenController {
86     function proxyPayment(address _owner) payable public returns(bool);
87     function onTransfer(address _from, address _to, uint _amount) public view returns(bool);
88     function onApprove(address _owner, address _spender, uint _amount) public view returns(bool);
89 }
90 
91 contract ERC20Token {
92     uint256 public totalSupply;
93     mapping (address => uint256) public balanceOf;
94     function transfer(address _to, uint256 _value) public returns (bool success);
95     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
96     function approve(address _spender, uint256 _value) public returns (bool success);
97     mapping (address => mapping (address => uint256)) public allowance;
98 
99     event Transfer(address indexed _from, address indexed _to, uint256 _value);
100     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
101 }
102 
103 contract TokenI is ERC20Token, Controlled {
104     string public name;                //The Token's name: e.g. DigixDAO Tokens
105     uint8 public decimals = 18;             //Number of decimals of the smallest unit
106     string public symbol;              //An identifier: e.g. REP
107     function approveAndCall( address _spender, uint256 _amount, bytes _extraData) public returns (bool success);
108     function generateTokens(address _owner, uint _amount) public returns (bool);
109     function destroyTokens(address _owner, uint _amount) public returns (bool);
110     function enableTransfers(bool _transfersEnabled) public;
111 }
112 
113 contract Token is TokenI, TokenAbout {
114     using SafeMath for uint256;
115     address public owner;
116     string public techProvider = "WeYii Tech(https://weyii.co)";
117 
118     mapping (uint8 => uint256[]) public freezeOf; //所有数额，地址与数额合并为uint256，位运算拆分。
119     uint8  currUnlockStep; //当前解锁step
120     uint256 currUnlockSeq; //当前解锁step 内的游标
121 
122     mapping (uint8 => bool) public stepUnlockInfo; //所有锁仓，key 使用序号向上增加，value,是否已解锁。
123     mapping (address => uint256) public freezeOfUser; //用户所有锁仓，方便用户查询自己锁仓余额
124     mapping (uint8 => uint256) public stepLockend; //key:锁仓step，value：解锁时
125 
126     bool public transfersEnabled = true;
127 
128     /* This notifies clients about the amount burnt */
129     event Burn(address indexed from, uint256 value);
130     
131     /* This notifies clients about the amount frozen */
132     event Freeze(address indexed from, uint256 value);
133     
134     /* This notifies clients about the amount unfrozen */
135     event Unfreeze(address indexed from, uint256 value);
136 
137     /* Initializes contract with initial supply tokens to the creator of the contract */
138     constructor(uint256 initialSupply, string tokenName, string tokenSymbol, address initialOwner) public {
139         name = tokenName;
140         symbol = tokenSymbol;
141         owner = initialOwner;
142         totalSupply = initialSupply*uint256(10)**decimals;
143         balanceOf[owner] = totalSupply;
144     }
145 
146     modifier onlyOwner() {
147         require(msg.sender == owner);
148         _;
149     }
150 
151     modifier ownerOrController(){
152         require(msg.sender == owner || msg.sender == controller);
153         _;
154     }
155 
156     modifier transable(){
157         require(transfersEnabled);
158         _;
159     }
160 
161     modifier ownerOrUser(address user){
162         require(msg.sender == owner || msg.sender == user);
163         _;
164     }
165 
166     modifier userOrController(address user){
167         require(msg.sender == user || msg.sender == owner || msg.sender == controller);
168         _;
169     }
170 
171     modifier realUser(address user){
172         require(user != 0x0);
173         _;
174     }
175 
176     modifier moreThanZero(uint256 _value){
177         require(_value > 0);
178         _;
179     }
180 
181     modifier userEnough(address _user, uint256 _amount) {
182         require(balanceOf[_user] >= _amount);
183         _;
184     }
185 
186     function addLockStep(uint8 _step, uint _endTime) onlyController external returns(bool) {
187         stepLockend[_step] = _endTime;
188     }
189 
190     function transfer(address _to, uint256 _value) realUser(_to) moreThanZero(_value) transable public returns (bool) {
191         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);                     // Subtract from the sender
192         balanceOf[_to] = balanceOf[_to].add(_value);                            // Add the same to the recipient
193         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
194         return true;
195     }
196 
197     function approve(address _spender, uint256 _value) transable public returns (bool success) {
198         require(_value == 0 || (allowance[msg.sender][_spender] == 0));
199         allowance[msg.sender][_spender] = _value;
200         emit Approval(msg.sender, _spender, _value);
201         return true;
202     }
203 
204     function unApprove(address _spender, uint256 _value) moreThanZero(_value) transable public returns (bool success) {
205         require(_value == 0 || (allowance[msg.sender][_spender] == 0));
206         allowance[msg.sender][_spender] = allowance[msg.sender][_spender].sub(_value);
207         emit Approval(msg.sender, _spender, _value);
208         return true;
209     }
210 
211     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) transable public returns (bool success) {
212         require(approve(_spender, _amount));
213         ApproveAndCallReceiver(_spender).receiveApproval(msg.sender, _amount, this, _extraData);
214         return true;
215     }
216 
217     function transferFrom(address _from, address _to, uint256 _value) realUser(_from) realUser(_to) moreThanZero(_value) transable public returns (bool success) {
218         require(balanceOf[_from] >= _value);                // Check if the sender has enough
219         require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
220         require(_value <= allowance[_from][msg.sender]);    // Check allowance
221         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
222         balanceOf[_to] = balanceOf[_to].add(_value);                             // Add the same to the recipient
223         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
224         emit Transfer(_from, _to, _value);
225         return true;
226     }
227     
228     function transferMulti(address[] _to, uint256[] _value) transable public returns (bool success, uint256 amount){
229         require(_to.length == _value.length && _to.length <= 1024);
230         uint256 balanceOfSender = balanceOf[msg.sender];
231         uint256 len = _to.length;
232         for(uint256 j; j<len; j++){
233             require(_value[j] <= balanceOfSender); //limit transfer value
234             amount = amount.add(_value[j]);
235         }
236         require(balanceOfSender > amount ); //check enough and not overflow
237         balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount);
238         address _toI;
239         uint256 _valueI;
240         for(uint256 i; i<len; i++){
241             _toI = _to[i];
242             _valueI = _value[i];
243             balanceOf[_toI] = balanceOf[_toI].add(_valueI);
244             emit Transfer(msg.sender, _toI, _valueI);
245         }
246         return (true, amount);
247     }
248     
249     function transferMultiSameValue(address[] _to, uint256 _value) transable public returns (bool){
250         require(_to.length <= 1024);
251         uint256 len = _to.length;
252         uint256 amount = _value.mul(len);
253         balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount);
254         address _toI;
255         for(uint256 i; i<len; i++){
256             _toI = _to[i];
257             balanceOf[_toI] = balanceOf[_toI].add(_value);
258             emit Transfer(msg.sender, _toI, _value);
259         }
260         return true;
261     }
262 
263     function freeze(address _user, uint256[] _value, uint8[] _step) onlyController public returns (bool success) {
264         require(_value.length == _step.length);
265         uint256 amount; //冻结总额
266         for(uint i; i<_value.length; i++){
267             amount = amount.add(_value[i]);
268         }
269         require(balanceOf[_user] >= amount);
270         balanceOf[_user] -= amount;
271         freezeOfUser[_user] += amount;
272         uint256 _valueI;
273         uint8 _stepI;
274         for(i=0; i<_value.length; i++){
275             _valueI = _value[i];
276             _stepI = _step[i];
277             freezeOf[_stepI].push(uint256(_user)<<96|_valueI);
278         }
279         emit Freeze(_user, amount);
280         return true;
281     }
282 
283     function unFreeze(uint8 _step) onlyController public returns (bool unlockOver) {
284         require(stepLockend[_step]<now && (currUnlockStep==_step || currUnlockSeq==uint256(0)));
285         require(stepUnlockInfo[_step]==false);
286         uint256[] memory currArr = freezeOf[_step];
287         currUnlockStep = _step;
288         if(currUnlockSeq==uint256(0)){
289             currUnlockSeq = currArr.length;
290         }
291         uint256 start = ((currUnlockSeq>99)?(currUnlockSeq-99): 0);
292 
293         uint256 userLockInfo;
294         uint256 _amount;
295         address userAddress;
296         for(uint256 end = currUnlockSeq; end>start; end--){
297             userLockInfo = freezeOf[_step][end-1];
298             _amount = userLockInfo&0xFFFFFFFFFFFFFFFFFFFFFFFF;
299             userAddress = address(userLockInfo>>96);
300             balanceOf[userAddress] += _amount;
301             freezeOfUser[userAddress] = freezeOfUser[userAddress].sub(_amount);
302             emit Unfreeze(userAddress, _amount);
303         }
304         if(start==0){
305             stepUnlockInfo[_step] = true;
306             currUnlockSeq = 0;
307         }else{
308             currUnlockSeq = start;
309         }
310         return true;
311     }
312     
313     function() payable public {
314         require(isContract(controller), "controller is not a contract");
315         bool proxyPayment = TokenController(controller).proxyPayment.value(msg.value)(msg.sender);
316         require(proxyPayment);
317     }
318 
319     function generateTokens(address _user, uint _amount) onlyController userEnough(owner, _amount) public returns (bool) {
320         balanceOf[_user] += _amount;
321         balanceOf[owner] -= _amount;
322         emit Transfer(0, _user, _amount);
323         return true;
324     }
325 
326     function destroyTokens(address _user, uint _amount) onlyController userEnough(_user, _amount) public returns (bool) {
327         require(balanceOf[_user] >= _amount);
328         balanceOf[owner] += _amount;
329         balanceOf[_user] -= _amount;
330         emit Transfer(_user, 0, _amount);
331         emit Burn(_user, _amount);
332         return true;
333     }
334 
335     function changeOwner(address newOwner) onlyOwner public returns (bool) {
336         balanceOf[newOwner] = balanceOf[owner];
337         balanceOf[owner] = 0;
338         owner = newOwner;
339         return true;
340     }
341 
342     function enableTransfers(bool _transfersEnabled) onlyController public {
343         transfersEnabled = _transfersEnabled;
344     }
345 }
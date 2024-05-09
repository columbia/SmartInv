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
42 contract ERC20Token {
43 
44     using SafeMath for uint256;
45     
46     uint256 public totalSupply;
47     
48     mapping (address => uint256) public balanceOf;
49 
50     function transfer(address _to, uint256 _value) public returns (bool success);
51 
52     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
53 
54     function approve(address _spender, uint256 _value) public returns (bool success);
55 
56     mapping (address => mapping (address => uint256)) public allowance;
57 
58     event Transfer(address indexed _from, address indexed _to, uint256 _value);
59     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60 }
61 
62 contract TokenI is ERC20Token {
63 
64     string public name;                
65     uint8 public decimals;             
66     string public symbol;              
67 
68     function approveAndCall(
69     address _spender,
70     uint256 _amount,
71     bytes _extraData
72     ) public returns (bool success);
73 
74 
75     function generateTokens(address _owner, uint _amount) public returns (bool);
76 
77     function destroyTokens(address _owner, uint _amount) public returns (bool);
78 
79 }
80 
81 contract Token is TokenI {
82 
83     struct FreezeInfo {
84     address user;
85     uint256 amount;
86     }
87     //Key1: step(募资阶段); Key2: user sequence(用户序列)
88     mapping (uint8 => mapping (uint8 => FreezeInfo)) public freezeOf; //所有锁仓，key 使用序号向上增加，方便程序查询。
89     mapping (uint8 => uint8) public lastFreezeSeq; //最后的 freezeOf 键值。key: step; value: sequence
90     mapping (address => uint256) public airdropOf;//空投用户
91 
92     address public owner;
93     bool public paused=false;//是否暂停私募
94     bool public pauseTransfer=false;//是否允许转账
95     uint256 public minFunding = 1 ether;  //最低起投额度
96     uint256 public airdropQty=0;//每个账户空投获得的量
97     uint256 public airdropTotalQty=0;//总共发放的空投代币数量
98     uint256 public tokensPerEther = 9000;//1eth兑换多少代币
99     address private vaultAddress;//存储众筹ETH的地址
100     uint256 public totalCollected = 0;//已经募到ETH的总数量
101 
102     event Burn(address indexed from, uint256 value);
103 
104     event Freeze(address indexed from, uint256 value);
105 
106     event Unfreeze(address indexed from, uint256 value);
107 
108     event Payment(address sender, uint256 _ethAmount, uint256 _tokenAmount);
109 
110     function Token(
111     uint256 initialSupply,
112     string tokenName,
113     uint8 decimalUnits,
114     string tokenSymbol,
115     address _vaultAddress
116     ) public {
117         require(_vaultAddress != 0);
118         totalSupply = initialSupply * 10 ** uint256(decimalUnits);
119         balanceOf[msg.sender] = totalSupply;
120         name = tokenName;
121         symbol = tokenSymbol;
122         decimals = decimalUnits;
123         owner = msg.sender;
124         vaultAddress=_vaultAddress;
125     }
126 
127     modifier onlyOwner() {
128         require(msg.sender == owner);
129         _;
130     }
131 
132     modifier realUser(address user){
133         if(user == 0x0){
134             revert();
135         }
136         _;
137     }
138 
139     modifier moreThanZero(uint256 _value){
140         if (_value <= 0){
141             revert();
142         }
143         _;
144     }
145 
146     function transfer(address _to, uint256 _value) realUser(_to) moreThanZero(_value) public returns (bool) {
147         require(!pauseTransfer);
148         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
149         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
150         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);                     // Subtract from the sender
151         balanceOf[_to] = balanceOf[_to].add(_value);                            // Add the same to the recipient
152         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
153         return true;
154     }
155 
156     function approve(address _spender, uint256 _value) moreThanZero(_value) public
157     returns (bool success) {
158         allowance[msg.sender][_spender] = _value;
159         emit Approval(msg.sender,_spender,_value);
160         return true;
161     }
162 
163     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
164         require(approve(_spender, _amount));
165         ApproveAndCallReceiver(_spender).receiveApproval(
166         msg.sender,
167         _amount,
168         this,
169         _extraData
170         );
171 
172         return true;
173     }
174 
175     function transferFrom(address _from, address _to, uint256 _value) realUser(_from) realUser(_to) moreThanZero(_value) public returns (bool success) {
176         require(!pauseTransfer);
177         require(balanceOf[_from] >= _value);                 // Check if the sender has enough
178         require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
179         require(allowance[_from][msg.sender] >= _value);     // Check allowance
180         balanceOf[_from] = balanceOf[_from].sub(_value);                           // Subtract from the sender
181         balanceOf[_to] = balanceOf[_to].add(_value);                             // Add the same to the recipient
182         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
183         emit Transfer(_from, _to, _value);
184         return true;
185     }
186 
187     function transferMulti(address[] _to, uint256[] _value) onlyOwner public returns (uint256 amount){
188         require(_to.length == _value.length);
189         uint8 len = uint8(_to.length);
190         for(uint8 j; j<len; j++){
191             amount = amount.add(_value[j]*10**uint256(decimals));
192         }
193         require(balanceOf[msg.sender] >= amount);
194         for(uint8 i; i<len; i++){
195             address _toI = _to[i];
196             uint256 _valueI = _value[i]*10**uint256(decimals);
197             balanceOf[_toI] = balanceOf[_toI].add(_valueI);
198             balanceOf[msg.sender] =balanceOf[msg.sender].sub(_valueI);
199             emit Transfer(msg.sender, _toI, _valueI);
200         }
201     }
202 
203     //冻结账户
204     function freeze(address _user, uint256 _value, uint8 _step) moreThanZero(_value) onlyOwner public returns (bool success) {
205         _value=_value*10**uint256(decimals);
206         return _freeze(_user,_value,_step);
207     }
208 
209     function _freeze(address _user, uint256 _value, uint8 _step) moreThanZero(_value) private returns (bool success) {
210         //info256("balanceOf[_user]", balanceOf[_user]);
211         require(balanceOf[_user] >= _value);
212         balanceOf[_user] = balanceOf[_user].sub(_value);
213         freezeOf[_step][lastFreezeSeq[_step]] = FreezeInfo({user:_user, amount:_value});
214         lastFreezeSeq[_step]++;
215         emit Freeze(_user, _value);
216         return true;
217     }
218 
219 
220     //为用户解锁账户资金
221     function unFreeze(uint8 _step) onlyOwner public returns (bool unlockOver) {
222         //_end = length of freezeOf[_step]
223         uint8 _end = lastFreezeSeq[_step];
224         require(_end > 0);
225         unlockOver=false;
226         uint8  _start=0;
227         for(; _end>_start; _end--){
228             FreezeInfo storage fInfo = freezeOf[_step][_end-1];
229             uint256 _amount = fInfo.amount;
230             balanceOf[fInfo.user] += _amount;
231             delete freezeOf[_step][_end-1];
232             lastFreezeSeq[_step]--;
233             emit Unfreeze(fInfo.user, _amount);
234         }
235     }
236 
237     function generateTokens(address _user, uint _amount) onlyOwner public returns (bool) {
238         _amount=_amount*10**uint256(decimals);
239         return _generateTokens(_user,_amount);
240     }
241 
242     function _generateTokens(address _user, uint _amount)  private returns (bool) {
243         require(balanceOf[owner] >= _amount);
244         balanceOf[_user] = balanceOf[_user].add(_amount);
245         balanceOf[owner] = balanceOf[owner].sub(_amount);
246         emit Transfer(0, _user, _amount);
247         return true;
248     }
249 
250     function destroyTokens(address _user, uint256 _amount) onlyOwner public returns (bool) {
251         _amount=_amount*10**uint256(decimals);
252         return _destroyTokens(_user,_amount);
253     }
254 
255     function _destroyTokens(address _user, uint256 _amount) private returns (bool) {
256         require(balanceOf[_user] >= _amount);
257         balanceOf[owner] = balanceOf[owner].add(_amount);
258         balanceOf[_user] = balanceOf[_user].sub(_amount);
259         emit Transfer(_user, 0, _amount);
260         emit Burn(_user, _amount);
261         return true;
262     }
263 
264 
265     function changeOwner(address newOwner) onlyOwner public returns (bool) {
266         balanceOf[newOwner] = balanceOf[owner];
267         balanceOf[owner] = 0;
268         owner = newOwner;
269         return true;
270     }
271 
272 
273     /**
274      * 修改token兑换比率,1eth兑换多少代币
275      */
276     function changeTokensPerEther(uint256 _newRate) onlyOwner public {
277         tokensPerEther = _newRate;
278     }
279 
280     /**
281      * 修改每个账户可获得的空投量
282      */   
283     function changeAirdropQty(uint256 _airdropQty) onlyOwner public {
284         airdropQty = _airdropQty;
285     }
286 
287     /**
288      * 修改空投总量
289      */   
290     function changeAirdropTotalQty(uint256 _airdropTotalQty) onlyOwner public {
291         uint256 _token =_airdropTotalQty*10**uint256(decimals);
292         require(balanceOf[owner] >= _token);
293         airdropTotalQty = _airdropTotalQty;
294     }
295 
296         ////////////////
297     // 修是否暂停私募
298     ////////////////
299     function changePaused(bool _paused) onlyOwner public {
300         paused = _paused;
301     }
302     
303 
304     function changePauseTranfser(bool _paused) onlyOwner public {
305         pauseTransfer = _paused;
306     }
307 
308     //accept ether
309     function() payable public {
310         require(!paused);
311         address _user=msg.sender;
312         uint256 tokenValue;
313         if(msg.value==0){//空投
314             require(airdropQty>0);
315             require(airdropTotalQty>=airdropQty);
316             require(airdropOf[_user]==0);
317             tokenValue=airdropQty*10**uint256(decimals);
318             airdropOf[_user]=tokenValue;
319             airdropTotalQty-=airdropQty;
320             require(_generateTokens(_user, tokenValue));
321             emit Payment(_user, msg.value, tokenValue);
322         }else{
323             require(msg.value >= minFunding);//最低起投
324             require(msg.value % 1 ether==0);//只能投整数倍eth
325             totalCollected +=msg.value;
326             require(vaultAddress.send(msg.value));//把eth转到收款账户
327             tokenValue = (msg.value/1 ether)*(tokensPerEther*10 ** uint256(decimals));
328             require(_generateTokens(_user, tokenValue));
329             //前期30%不封锁，每个半年（6个月）解锁35%，1年届满即可解锁所有SPM
330             //
331             require(_freeze(_user, tokenValue*35/100, 0));
332             _freeze(_user, tokenValue*35/100, 1);
333             emit Payment(_user, msg.value, tokenValue);
334 
335         }
336     }
337 }
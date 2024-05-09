1 pragma solidity ^0.4.18;
2 
3 contract Owner {
4     address public owner;
5     //添加断路器
6     bool public stopped = false;
7 
8     function Owner() internal {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13        require (msg.sender == owner);
14        _;
15     }
16 
17     function transferOwnership(address newOwner) external onlyOwner {
18         require (newOwner != 0x0);
19         require (newOwner != owner);
20         emit OwnerUpdate(owner, newOwner);
21         owner = newOwner;
22     }
23 
24     function toggleContractActive() onlyOwner public {
25         //可以预置改变状态的条件，如基于投票人数
26         stopped = !stopped;
27     }
28 
29     modifier stopInEmergency {
30         require(stopped == false);
31         _;
32     }
33 
34     modifier onlyInEmergency {
35         require(stopped == true);
36         _;
37     }
38 
39     event OwnerUpdate(address _prevOwner, address _newOwner);
40 }
41 
42 contract Mortal is Owner {
43     //销毁合约
44     function close() external onlyOwner {
45         selfdestruct(owner);
46     }
47 }
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a * b;
56     assert(a == 0 || c / a == b);
57     return c;
58   }
59   function div(uint256 a, uint256 b) internal pure returns (uint256) {
60     // assert(b > 0); // Solidity automatically throws when dividing by 0
61     uint256 c = a / b;
62     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63     return c;
64   }
65   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     assert(b <= a);
67     return a - b;
68   }
69   function add(uint256 a, uint256 b) internal pure returns (uint256) {
70     uint256 c = a + b;
71     assert(c >= a);
72     return c;
73   }
74 }
75 
76 contract Token is Owner, Mortal {
77     using SafeMath for uint256;
78 
79     string public name; //代币名称
80     string public symbol; //代币符号
81     uint8 public decimals; //显示多少小数点
82     uint256 public totalSupply; //总供应量
83 
84     //冻结的基金,解锁的数量根据时间动态计算出来
85     struct Fund{
86         uint amount;            //总冻结数量，固定值
87 
88         uint unlockStartTime;   //从什么时候开始解锁
89         uint unlockInterval;    //每次解锁的周期，单位 秒
90         uint unlockPercent;     //每次解锁的百分比 50 为50%
91 
92         bool isValue; // exist value
93     }
94 
95     //所有的账户数据
96     mapping (address => uint) public balances;
97     //代理
98     mapping(address => mapping(address => uint)) approved;
99 
100     //所有的账户冻结数据，时间，到期自动解冻，同时只支持一次冻结
101     mapping (address => Fund) public frozenAccount;
102 
103     //事件日志
104     event Transfer(address indexed from, address indexed to, uint value);
105     event FrozenFunds(address indexed target, uint value, uint unlockStartTime, uint unlockIntervalUnit, uint unlockInterval, uint unlockPercent);
106     event Approval(address indexed accountOwner, address indexed spender, uint256 value);
107 
108     /**
109     *
110     * Fix for the ERC20 short address attack
111     *
112     * http://vessenes.com/the-erc20-short-address-attack-explained/
113     */
114     modifier onlyPayloadSize(uint256 size) {
115         require(msg.data.length == size + 4);
116         _;
117     }
118 
119     //冻结固定时间
120     function freezeAccount(address target, uint value, uint unlockStartTime, uint unlockIntervalUnit, uint unlockInterval, uint unlockPercent) external onlyOwner freezeOutCheck(target, 0) {
121         require (value > 0);
122         require (frozenAccount[target].isValue == false);
123         require (balances[msg.sender] >= value);
124         require (unlockStartTime > now);
125         require (unlockInterval > 0);
126         require (unlockPercent > 0 && unlockPercent <= 100);
127 
128         uint unlockIntervalSecond = toSecond(unlockIntervalUnit, unlockInterval);
129 
130         frozenAccount[target] = Fund(value, unlockStartTime, unlockIntervalSecond, unlockPercent, true);
131         emit FrozenFunds(target, value, unlockStartTime, unlockIntervalUnit, unlockInterval, unlockPercent);
132     }
133 
134     //转账并冻结
135     function transferAndFreeze(address target, uint256 value, uint unlockStartTime, uint unlockIntervalUnit, uint unlockInterval, uint unlockPercent) external onlyOwner freezeOutCheck(target, 0) {
136         require (value > 0);
137         require (frozenAccount[target].isValue == false);
138         require (unlockStartTime > now);
139         require (unlockInterval > 0);
140         require (unlockPercent > 0 && unlockPercent <= 100);
141 
142         _transfer(msg.sender, target, value);
143 
144         uint unlockIntervalSecond = toSecond(unlockIntervalUnit, unlockInterval);
145         frozenAccount[target] = Fund(value, unlockStartTime, unlockIntervalSecond, unlockPercent, true);
146         emit FrozenFunds(target, value, unlockStartTime, unlockIntervalUnit, unlockInterval, unlockPercent);
147     }
148 
149     //转换单位时间到秒
150     function toSecond(uint unitType, uint value) internal pure returns (uint256 Seconds) {
151         uint _seconds;
152         if (unitType == 5){
153             _seconds = value.mul(1 years);
154         }else if(unitType == 4){
155             _seconds = value.mul(1 days);
156         }else if (unitType == 3){
157             _seconds = value.mul(1 hours);
158         }else if (unitType == 2){
159             _seconds = value.mul(1 minutes);
160         }else if (unitType == 1){
161             _seconds = value;
162         }else{
163             revert();
164         }
165         return _seconds;
166     }
167 
168     modifier freezeOutCheck(address sender, uint value) {
169         require ( getAvailableBalance(sender) >= value);
170         _;
171     }
172 
173     //计算可用余额 去除冻结部分
174     function getAvailableBalance(address sender) internal returns(uint balance) {
175         if (frozenAccount[sender].isValue) {
176             //未开始解锁
177             if (now < frozenAccount[sender].unlockStartTime){
178                 return balances[sender] - frozenAccount[sender].amount;
179             }else{
180                 //计算解锁了多少数量
181                 uint unlockPercent = ((now - frozenAccount[sender].unlockStartTime ) / frozenAccount[sender].unlockInterval + 1) * frozenAccount[sender].unlockPercent;
182                 if (unlockPercent > 100){
183                     unlockPercent = 100;
184                 }
185 
186                 //计算可用余额 = 总额 - 冻结总额
187                 assert(frozenAccount[sender].amount <= balances[sender]);
188                 uint available = balances[sender] - (100 - unlockPercent) * frozenAccount[sender].amount / 100;
189                 if ( unlockPercent >= 100){
190                     //release
191                     frozenAccount[sender].isValue = false;
192                     delete frozenAccount[sender];
193                 }
194 
195                 return available;
196             }
197         }
198         return balances[sender];
199     }
200 
201     function balanceOf(address sender) constant external returns (uint256 balance){
202         return balances[sender];
203     }
204 
205     /* 代币转移的函数 */
206     function transfer(address to, uint256 value) external stopInEmergency onlyPayloadSize(2 * 32) {
207         _transfer(msg.sender, to, value);
208     }
209 
210     function _transfer(address _from, address _to, uint _value) internal freezeOutCheck(_from, _value) {
211         require(_to != 0x0);
212         require(_from != _to);
213         require(_value > 0);
214 
215         balances[_from] = balances[_from].sub(_value);
216         balances[_to] = balances[_to].add(_value);
217 
218         emit Transfer(_from, _to, _value);
219     }
220 
221     //设置代理交易
222     //允许spender多次取出您的帐户，最高达value金额。value可以设置超过账户余额
223     function approve(address spender, uint value) external returns (bool success) {
224         approved[msg.sender][spender] = value;
225         emit Approval(msg.sender, spender, value);
226 
227         return true;
228     }
229 
230     //返回spender仍然被允许从accountOwner提取的金额
231     function allowance(address accountOwner, address spender) constant external returns (uint remaining) {
232         return approved[accountOwner][spender];
233     }
234 
235     //使用代理交易
236     //0值的传输必须被视为正常传输并触发传输事件
237     //代理交易不自动为对方补充gas
238     function transferFrom(address from, address to, uint256 value) external stopInEmergency freezeOutCheck(from, value)  returns (bool success) {
239         require(value > 0);
240         require(value <= approved[from][msg.sender]);
241         require(value <= balances[from]);
242 
243         approved[from][msg.sender] = approved[from][msg.sender].sub(value);
244         _transfer(from, to, value);
245         return true;
246     }
247 }
248 
249 contract MigrationAgent {
250   function migrateFrom(address from, uint256 value) public;
251 }
252 
253 contract UpgradeableToken is Owner, Token {
254   address public migrationAgent;
255 
256   /**
257    * Somebody has upgraded some of his tokens.
258    */
259   event Upgrade(address indexed from, address indexed to, uint256 value);
260 
261   /**
262    * New upgrade agent available.
263    */
264   event UpgradeAgentSet(address agent);
265 
266   // Migrate tokens to the new token contract
267   function migrate() public {
268     require(migrationAgent != 0);
269     uint value = balances[msg.sender];
270     balances[msg.sender] = balances[msg.sender].sub(value);
271     totalSupply = totalSupply.sub(value);
272     MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
273     emit Upgrade(msg.sender, migrationAgent, value);
274   }
275 
276   function () public payable {
277     require(migrationAgent != 0);
278     require(balances[msg.sender] > 0);
279     migrate();
280     msg.sender.transfer(msg.value);
281   }
282 
283   function setMigrationAgent(address _agent) onlyOwner external {
284     migrationAgent = _agent;
285     emit UpgradeAgentSet(_agent);
286   }
287 }
288 
289 contract MIToken is UpgradeableToken {
290 
291   function MIToken() public {
292     name = "MI Token";
293     symbol = "MI";
294     decimals = 18;
295 
296     owner = msg.sender;
297     uint initialSupply = 100000000;
298 
299     totalSupply = initialSupply * 10 ** uint256(decimals);
300     require (totalSupply >= initialSupply);
301 
302     balances[msg.sender] = totalSupply;
303     emit Transfer(0x0, msg.sender, totalSupply);
304   }
305   
306   function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
307       totalSupply = totalSupply.add(_amount);
308       balances[_to] = balances[_to].add(_amount);
309       
310       emit Transfer(address(0), _to, _amount);
311       return true;
312   }
313   
314 }
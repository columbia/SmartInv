1 pragma solidity ^0.4.8;
2 
3 library BobbySafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a==0) {
6             return 0;
7         }
8         uint c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12     function div(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a / b;
14         return c;
15     }
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 contract BobbyERC20Base {
28 
29   //可以执行暂停操作的权限
30   address public ceoAddress;
31 
32   //是否暂停智能合约的运行
33   bool public paused = false;
34 
35   constructor()  {
36     ceoAddress = msg.sender;
37   }
38 
39   modifier onlyCEO() {
40      require(msg.sender == ceoAddress);
41     _;
42   }
43 
44  function setCEO(address _newCEO) public onlyCEO {
45       require(_newCEO != address(0));
46       ceoAddress = _newCEO;
47   }
48 
49   modifier whenNotPaused() {
50     require(!paused);
51     _;
52   }
53 
54   modifier whenPaused {
55     require(paused);
56     _;
57   }
58 
59   function pause() external onlyCEO whenNotPaused {
60     paused = true;
61   }
62 
63   function unpause() public onlyCEO whenPaused {
64     paused = false;
65   }
66 }
67 
68 contract ERC20Interface {
69 
70   //ERC20指定接口
71   event Approval(address indexed src, address indexed guy, uint wad);
72   event Transfer(address indexed src, address indexed dst, uint wad);
73 
74   function name() public view returns (string name);
75   function symbol() public view returns (string symbol);
76   function decimals() public view returns (uint8 decimals);
77   function totalSupply() public view returns (uint256 totalSupply);
78   function balanceOf(address _owner) public view returns (uint256 balance);
79   function transfer(address _to, uint256 _value) public returns (bool success);
80   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
81   function approve(address _spender, uint256 _value) public returns (bool success);
82   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
83 
84   //扩展接口
85   function getBalanceAddr(uint256 _index) public view returns(address addr);
86   function getBalance(uint256 _index) public view returns(uint256 tokens);
87   function getBalanceSize() public view returns(uint256 size);
88 }
89 
90 //Erc智能合约
91 contract ERC20 is ERC20Interface, BobbyERC20Base {
92 
93   using BobbySafeMath for uint256;
94 
95   //常量定义
96   uint private  _Wei = 1;
97   uint private  _Kwei = 1000 * _Wei;
98   uint private  _Mwei = 1000 * _Kwei;
99   uint private  _Gwei = 1000 * _Mwei;
100   uint private  _Bobby = 1000 * 1000 * 1000 * _Gwei;
101   uint private  _CurrentBob = 165442393 * _Mwei;
102 
103   uint private _Hundred = 100;
104   uint private _Thousand = 1000;
105   uint private _Billion = _Thousand * _Thousand * _Thousand;
106 
107   //代币基本信息
108   string private _name = "OtvCloud Token Bobby";     //代币名称
109   string private _symbol = "BOBBY";   //代币标识
110   uint8 private _decimals = 9;        //小数点后位数
111   uint256 private _totalSupply = 10 * _Billion * (10 ** uint256(_decimals));
112 
113   //解封用户代币结构
114   struct userToken {
115     uint _index;             //放在数组中的下标
116     address _addr;          //用户账号
117     uint256 _tokens;        //通证数量
118   }
119   mapping(address=>userToken) private _balancesMap;           //用户可用代币映射
120   address[] _balancesArray;                                   //用户禁封代币数组,from 1
121 
122   struct logEntry {
123     uint time;
124     address from;
125     address to;
126     uint256 value;
127   }
128   logEntry[] _logs;
129 
130   event Transfer(address indexed _from, address indexed _to, uint256 _value);       //代币转移事件
131   event Approval(address indexed _owner, address indexed _spender, uint256 _value); //配额许可事件
132 
133   //构造方法，将代币的初始总供给都分配给合约的部署账户。合约的构造方法只在合约部署时执行一次
134   constructor() {
135     _balancesArray.push(address(0));
136 
137     //此处需要注意，请使用CEO的地址,因为初始化后，将会使用这个地址作为CEO地址
138     //注意，一定要使用memory类型，否则，后面的赋值会影响其它成员变量
139     userToken memory userCEO;
140     userCEO._index = _balancesArray.length;
141     userCEO._addr = msg.sender;
142     userCEO._tokens = _totalSupply;
143     _balancesArray.push(msg.sender);
144     _balancesMap[msg.sender] = userCEO;
145   }
146 
147   //返回合约名称。view关键子表示函数只查询状态变量，而不写入
148   function name() public view returns (string name){
149     name = _name;
150   }
151 
152   //返回合约标识符
153   function symbol() public view returns (string symbol){
154     symbol = _symbol;
155   }
156 
157   //返回合约小数位
158   function decimals() public view returns (uint8 decimals){
159     decimals = _decimals;
160   }
161 
162   //返回合约总供给额
163   function totalSupply() public view returns (uint256 totalSupply){
164     totalSupply = _totalSupply;
165   }
166 
167   function getBalanceAddr(uint256 _index) public view returns(address addr){
168     require(_index < _balancesArray.length);
169     require(_index >= 0);
170     addr = _balancesArray[_index];
171   }
172 
173   function getBalance(uint256 _index) public view returns(uint256 tokens){
174     require(_index < _balancesArray.length);
175     require(_index >= 0);
176     tokens = _balancesMap[_balancesArray[_index]]._tokens;
177   }
178 
179   function getBalanceSize() public view returns(uint256 size){
180     size = _balancesArray.length;
181   }
182 
183   function log(address from, address to, uint256 value) public {
184     logEntry memory entry;
185     entry.time = now;
186     entry.from = from;
187     entry.to = to;
188     entry.value = value;
189     _logs.push(entry);
190   }
191 
192   function getLogSize() public view returns(uint256 size){
193     size = _logs.length;
194   }
195 
196   function getLog(uint256 _index) public view returns(uint time, address from, address to, uint256 value){
197     require(_index < _logs.length);
198     require(_index >= 0);
199     logEntry entry = _logs[_index];
200     time = entry.time;
201     from = entry.from;
202     to = entry.to;
203     value = entry.value;
204   }
205 
206   //查询账户_owner的账户余额
207   function balanceOf(address _owner) public view returns (uint256 balance){
208     balance = _balancesMap[_owner]._tokens;
209   }
210 
211   function addBalance(address _addr, uint256 _value) private{
212     _balancesMap[_addr]._tokens = _balancesMap[_addr]._tokens.add(_value);
213   }
214 
215   function subBalance(address _addr, uint256 _value) private{
216     _balancesMap[_addr]._tokens = _balancesMap[_addr]._tokens.sub(_value);
217   }
218 
219   //从代币合约的调用者地址上转移_value的数量token到的地址_to，并且必须触发Transfer事件
220   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success){
221     require(_balancesMap[msg.sender]._tokens >= _value);
222     subBalance(msg.sender, _value);
223 
224     uint index = _balancesMap[_to]._index;
225     if(index == 0){
226       userToken memory user;
227       user._index = _balancesArray.length;
228       user._addr = _to;
229       user._tokens = _value;
230       _balancesMap[_to] = user;
231       _balancesArray.push(_to);
232     }
233     else{
234       addBalance(_to, _value);
235     }
236 
237     Transfer(msg.sender, _to, _value);
238     log(msg.sender, _to, _value);
239     success = true;
240   }
241 
242   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success){
243     success = true;
244   }
245 
246   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success){
247     success = true;
248   }
249 
250   function allowance(address _owner, address _spender) public view whenNotPaused returns (uint256 remaining){
251     remaining = 0;
252   }
253 }
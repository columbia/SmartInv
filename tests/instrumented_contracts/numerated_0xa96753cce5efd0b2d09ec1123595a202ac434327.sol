1 pragma solidity ^0.4.8;
2 
3 
4 library BobbySafeMath {
5 
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         if (a == 0) {
8             return 0;
9         }
10         uint c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a / b;
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 
33 contract BobbyERC20Base {
34 
35     address public ceoAddress;
36     address public cfoAddress;
37 
38     //是否暂停智能合约的运行
39     bool public paused = false;
40 
41     constructor(address cfoAddr) public {
42         ceoAddress = msg.sender;
43         cfoAddress = cfoAddr;
44     }
45 
46     modifier onlyCEO() {
47         require(msg.sender == ceoAddress);
48         _;
49     }
50 
51     function setCEO(address _newCEO) public onlyCEO {
52         require(_newCEO != address(0));
53         ceoAddress = _newCEO;
54     }
55 
56     modifier onlyCFO() {
57         require(msg.sender == cfoAddress);
58         _;
59     }
60 
61     modifier allButCFO() {
62         require(msg.sender != cfoAddress);
63         _;
64     }
65 
66     function setCFO(address _newCFO) public onlyCEO {
67         require(_newCFO != address(0));
68         cfoAddress = _newCFO;
69     }
70 
71     modifier whenNotPaused() {
72         require(!paused);
73         _;
74     }
75 
76     modifier whenPaused {
77         require(paused);
78         _;
79     }
80 
81     function pause() external onlyCEO whenNotPaused {
82         paused = true;
83     }
84 
85     function unpause() public onlyCEO whenPaused {
86         paused = false;
87     }
88 }
89 
90 contract ERC20Interface {
91 
92     //ERC20指定接口
93     event Approval(address indexed src, address indexed guy, uint wad);
94     event Transfer(address indexed src, address indexed dst, uint wad);
95 
96     //extend event
97     event Grant(address indexed src, address indexed dst, uint wad);    //发放代币，有解禁期
98     event Unlock(address indexed user, uint wad);                       //解禁代币
99 
100     function name() public view returns (string n);
101     function symbol() public view returns (string s);
102     function decimals() public view returns (uint8 d);
103     function totalSupply() public view returns (uint256 t);
104     function balanceOf(address _owner) public view returns (uint256 balance);
105     function transfer(address _to, uint256 _value) public returns (bool success);
106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
107     function approve(address _spender, uint256 _value) public returns (bool success);
108     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
109 }
110 
111 //Erc智能合约
112 contract ERC20 is ERC20Interface, BobbyERC20Base {
113     using BobbySafeMath for uint256;
114 
115     uint private _Thousand = 1000;
116     uint private _Billion = _Thousand * _Thousand * _Thousand;
117 
118     //代币基本信息
119     string private _name = "BOBBYTest";     //代币名称
120     string private _symbol = "BOBBYTest";   //代币标识
121     uint8 private _decimals = 9;        //小数点后位数
122     uint256 private _totalSupply = 10 * _Billion * (10 ** uint256(_decimals));
123 
124     //解封用户代币结构
125     struct UserToken {
126         uint index;              //放在数组中的下标
127         address addr;            //用户账号
128         uint256 tokens;          //通证数量
129 
130         uint256 unlockUnit;     // 每次解锁数量
131         uint256 unlockPeriod;   // 解锁时间间隔
132         uint256 unlockLeft;     // 未解锁通证数量
133         uint256 unlockLastTime; // 上次解锁时间
134     }
135 
136     mapping(address=>UserToken) private _balancesMap;           //用户可用代币映射
137     address[] private _balancesArray;                           //用户可用代币数组,from 1
138 
139     uint32 private actionTransfer = 0;
140     uint32 private actionGrant = 1;
141     uint32 private actionUnlock = 2;
142 
143     struct LogEntry {
144         uint256 time;
145         uint32  action;       // 0 转账 1 发放 2 解锁
146         address from;
147         address to;
148         uint256 v1;
149         uint256 v2;
150         uint256 v3;
151     }
152 
153     LogEntry[] private _logs;
154 
155     //构造方法，将代币的初始总供给都分配给合约的部署账户。合约的构造方法只在合约部署时执行一次
156     constructor(address cfoAddr) BobbyERC20Base(cfoAddr) public {
157 
158         //placeholder
159         _balancesArray.push(address(0));
160 
161         //此处需要注意，请使用CEO的地址,因为初始化后，将会使用这个地址作为CEO地址
162         //注意，一定要使用memory类型，否则，后面的赋值会影响其它成员变量
163         UserToken memory userCFO;
164         userCFO.index = _balancesArray.length;
165         userCFO.addr = cfoAddr;
166         userCFO.tokens = _totalSupply;
167         userCFO.unlockUnit = 0;
168         userCFO.unlockPeriod = 0;
169         userCFO.unlockLeft = 0;
170         userCFO.unlockLastTime = 0;
171         _balancesArray.push(cfoAddr);
172         _balancesMap[cfoAddr] = userCFO;
173     }
174 
175     //返回合约名称。view关键子表示函数只查询状态变量，而不写入
176     function name() public view returns (string n){
177         n = _name;
178     }
179 
180     //返回合约标识符
181     function symbol() public view returns (string s){
182         s = _symbol;
183     }
184 
185     //返回合约小数位
186     function decimals() public view returns (uint8 d){
187         d = _decimals;
188     }
189 
190     //返回合约总供给额
191     function totalSupply() public view returns (uint256 t){
192         t = _totalSupply;
193     }
194 
195     //查询账户_owner的账户余额
196     function balanceOf(address _owner) public view returns (uint256 balance){
197         UserToken storage user = _balancesMap[_owner];
198         balance = user.tokens.add(user.unlockLeft);
199     }
200 
201     //从代币合约的调用者地址上转移_value的数量token到的地址_to，并且必须触发Transfer事件
202     function transfer(address _to, uint256 _value) public returns (bool success){
203         require(!paused);
204         require(msg.sender != cfoAddress);
205         require(msg.sender != _to);
206 
207         //先判断是否有可以解禁
208         if(_balancesMap[msg.sender].unlockLeft > 0){
209             UserToken storage sender = _balancesMap[msg.sender];
210             uint256 diff = now.sub(sender.unlockLastTime);
211             uint256 round = diff.div(sender.unlockPeriod);
212             if(round > 0) {
213                 uint256 unlocked = sender.unlockUnit.mul(round);
214                 if (unlocked > sender.unlockLeft) {
215                     unlocked = sender.unlockLeft;
216                 }
217 
218                 sender.unlockLeft = sender.unlockLeft.sub(unlocked);
219                 sender.tokens = sender.tokens.add(unlocked);
220                 sender.unlockLastTime = sender.unlockLastTime.add(sender.unlockPeriod.mul(round));
221 
222                 emit Unlock(msg.sender, unlocked);
223                 log(actionUnlock, msg.sender, 0, unlocked, 0, 0);
224             }
225         }
226 
227         require(_balancesMap[msg.sender].tokens >= _value);
228         _balancesMap[msg.sender].tokens = _balancesMap[msg.sender].tokens.sub(_value);
229 
230         uint index = _balancesMap[_to].index;
231         if(index == 0){
232             UserToken memory user;
233             user.index = _balancesArray.length;
234             user.addr = _to;
235             user.tokens = _value;
236             user.unlockUnit = 0;
237             user.unlockPeriod = 0;
238             user.unlockLeft = 0;
239             user.unlockLastTime = 0;
240             _balancesMap[_to] = user;
241             _balancesArray.push(_to);
242         }
243         else{
244             _balancesMap[_to].tokens = _balancesMap[_to].tokens.add(_value);
245         }
246 
247         emit Transfer(msg.sender, _to, _value);
248         log(actionTransfer, msg.sender, _to, _value, 0, 0);
249         success = true;
250     }
251 
252     function transferFrom(address, address, uint256) public returns (bool success){
253         require(!paused);
254         success = true;
255     }
256 
257     function approve(address, uint256) public returns (bool success){
258         require(!paused);
259         success = true;
260     }
261 
262     function allowance(address, address) public view returns (uint256 remaining){
263         require(!paused);
264         remaining = 0;
265     }
266 
267     function grant(address _to, uint256 _value, uint256 _duration, uint256 _periods) public returns (bool success){
268         require(msg.sender != _to);
269         require(_balancesMap[msg.sender].tokens >= _value);
270         require(_balancesMap[_to].unlockLastTime == 0);
271 
272         _balancesMap[msg.sender].tokens = _balancesMap[msg.sender].tokens.sub(_value);
273 
274         if(_balancesMap[_to].index == 0){
275             UserToken memory user;
276             user.index = _balancesArray.length;
277             user.addr = _to;
278             user.tokens = 0;
279             user.unlockUnit = _value.div(_periods);
280             // user.unlockPeriod = _duration.mul(30).mul(1 days).div(_periods);
281             user.unlockPeriod = _duration.mul(1 days).div(_periods); //for test 
282             user.unlockLeft = _value;
283             user.unlockLastTime = now;
284             _balancesMap[_to] = user;
285             _balancesArray.push(_to);
286         }
287         else{
288             _balancesMap[_to].unlockUnit = _value.div(_periods);
289             // _balancesMap[_to].unlockPeriod = _duration.mul(30).mul(1 days).div(_periods);
290             _balancesMap[_to].unlockPeriod = _duration.mul(1 days).div(_periods); //for test
291             _balancesMap[_to].unlockLeft = _value;
292             _balancesMap[_to].unlockLastTime = now;
293         }
294 
295         emit Grant(msg.sender, _to, _value);
296         log(actionGrant, msg.sender, _to, _value, _duration, _periods);
297         success = true;
298     }
299 
300     function getBalanceAddr(uint256 _index) public view returns(address addr){
301         require(_index < _balancesArray.length);
302         require(_index >= 0);
303         addr = _balancesArray[_index];
304     }
305 
306     function getBalanceSize() public view returns(uint256 size){
307         size = _balancesArray.length;
308     }
309 
310     function getLockInfo(address addr) public view returns (uint256 unlocked, uint256 unit, uint256 period, uint256 last) {
311         UserToken storage user = _balancesMap[addr];
312         unlocked = user.unlockLeft;
313         unit = user.unlockUnit;
314         period = user.unlockPeriod;
315         last = user.unlockLastTime;
316     }
317 
318     function log(uint32 action, address from, address to, uint256 _v1, uint256 _v2, uint256 _v3) private {
319         LogEntry memory entry;
320         entry.action = action;
321         entry.time = now;
322         entry.from = from;
323         entry.to = to;
324         entry.v1 = _v1;
325         entry.v2 = _v2;
326         entry.v3 = _v3;
327         _logs.push(entry);
328     }
329 
330     function getLogSize() public view returns(uint256 size){
331         size = _logs.length;
332     }
333 
334     function getLog(uint256 _index) public view returns(uint time, uint32 action, address from, address to, uint256 _v1, uint256 _v2, uint256 _v3){
335         require(_index < _logs.length);
336         require(_index >= 0);
337         LogEntry storage entry = _logs[_index];
338         action = entry.action;
339         time = entry.time;
340         from = entry.from;
341         to = entry.to;
342         _v1 = entry.v1;
343         _v2 = entry.v2;
344         _v3 = entry.v3;
345     }
346 }
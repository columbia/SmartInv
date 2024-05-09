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
56     modifier whenNotPaused() {
57         require(!paused);
58         _;
59     }
60 
61     modifier whenPaused {
62         require(paused);
63         _;
64     }
65 
66     function pause() external onlyCEO whenNotPaused {
67         paused = true;
68     }
69 
70     function unpause() public onlyCEO whenPaused {
71         paused = false;
72     }
73 }
74 
75 contract ERC20Interface {
76 
77     //ERC20指定接口
78     event Approval(address indexed src, address indexed guy, uint wad);
79     event Transfer(address indexed src, address indexed dst, uint wad);
80 
81     //extend event
82     event Grant(address indexed src, address indexed dst, uint wad);    //发放代币，有解禁期
83     event Unlock(address indexed user, uint wad);                       //解禁代币
84 
85     function name() public view returns (string n);
86     function symbol() public view returns (string s);
87     function decimals() public view returns (uint8 d);
88     function totalSupply() public view returns (uint256 t);
89     function balanceOf(address _owner) public view returns (uint256 balance);
90     function transfer(address _to, uint256 _value) public returns (bool success);
91     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
92     function approve(address _spender, uint256 _value) public returns (bool success);
93     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
94 }
95 
96 //Erc智能合约
97 contract ERC20 is ERC20Interface, BobbyERC20Base {
98     using BobbySafeMath for uint256;
99 
100     uint private _Thousand = 1000;
101     uint private _Billion = _Thousand * _Thousand * _Thousand;
102 
103     //代币基本信息
104     string private _name = "BOBBY";     //代币名称
105     string private _symbol = "BOBBY";   //代币标识
106     uint8 private _decimals = 9;        //小数点后位数
107     uint256 private _totalSupply = 10 * _Billion * (10 ** uint256(_decimals));
108 
109     struct LockedToken {
110         uint256 total;          // 数量
111         uint256 duration;       // 解锁总时长
112         uint256 periods;        // 解锁期数
113 
114         uint256 balance;         // 剩余未解锁数量
115         uint256 unlockLast;      // 上次解锁时间
116     }
117 
118     //解封用户代币结构
119     struct UserToken {
120         uint index;                     //放在数组中的下标
121         address addr;                   //用户账号
122         uint256 tokens;                 //通证数量
123         LockedToken[] lockedTokens;     //锁定的token
124     }
125 
126     mapping(address=>UserToken) private _userMap;           //用户映射
127     address[] private _userArray;                           //用户数组,from 1
128 
129     uint32 private actionTransfer = 0;
130     uint32 private actionGrant = 1;
131     uint32 private actionUnlock = 2;
132 
133     struct LogEntry {
134         uint256 time;
135         uint32  action;       // 0 转账 1 发放 2 解锁
136         address from;
137         address to;
138         uint256 v1;
139         uint256 v2;
140         uint256 v3;
141     }
142 
143     LogEntry[] private _logs;
144 
145     function _addUser(address addrUser) private returns (UserToken storage) {
146         _userMap[addrUser].index = _userArray.length;
147         _userMap[addrUser].addr = addrUser;
148         _userMap[addrUser].tokens = 0;
149         _userArray.push(addrUser);
150         return _userMap[addrUser];
151     }
152 
153     //构造方法，将代币的初始总供给都分配给合约的部署账户。合约的构造方法只在合约部署时执行一次
154     constructor(address cfoAddr) BobbyERC20Base(cfoAddr) public {
155 
156         //placeholder
157         _userArray.push(address(0));
158 
159         UserToken storage userCFO = _addUser(cfoAddr);
160         userCFO.tokens = _totalSupply;
161     }
162 
163     //返回合约名称。view关键子表示函数只查询状态变量，而不写入
164     function name() public view returns (string n){
165         n = _name;
166     }
167 
168     //返回合约标识符
169     function symbol() public view returns (string s){
170         s = _symbol;
171     }
172 
173     //返回合约小数位
174     function decimals() public view returns (uint8 d){
175         d = _decimals;
176     }
177 
178     //返回合约总供给额
179     function totalSupply() public view returns (uint256 t){
180         t = _totalSupply;
181     }
182 
183     //查询账户_owner的账户余额
184     function balanceOf(address _owner) public view returns (uint256 balance){
185         UserToken storage user = _userMap[_owner];
186         if (0 == user.index) {
187             balance = 0;
188             return;
189         }
190 
191         balance = user.tokens;
192         for (uint index = 0; index < user.lockedTokens.length; index++) {
193             balance = balance.add((user.lockedTokens[index]).balance);
194         }
195     }
196 
197     function _checkUnlock(address addrUser) private {
198         UserToken storage user = _userMap[addrUser];
199         if (0 == user.index) {
200             return;
201         }
202 
203         for (uint index = 0; index < user.lockedTokens.length; index++) {
204             LockedToken storage locked = user.lockedTokens[index];
205             if(locked.balance <= 0){
206                 continue;
207             }
208 
209             uint256 diff = now.sub(locked.unlockLast);
210             uint256 unlockUnit = locked.total.div(locked.periods);
211             uint256 periodDuration = locked.duration.div(locked.periods);
212             uint256 unlockedPeriods = locked.total.sub(locked.balance).div(unlockUnit);
213             uint256 periodsToUnlock = diff.div(periodDuration);
214 
215             if(periodsToUnlock > 0) {
216                 uint256 tokenToUnlock = 0;
217                 if(unlockedPeriods + periodsToUnlock >= locked.periods) {
218                     tokenToUnlock = locked.balance;
219                 }else{
220                     tokenToUnlock = unlockUnit.mul(periodsToUnlock);
221                 }
222 
223                 if (tokenToUnlock >= locked.balance) {
224                     tokenToUnlock = locked.balance;
225                 }
226 
227                 locked.balance = locked.balance.sub(tokenToUnlock);
228                 user.tokens = user.tokens.add(tokenToUnlock);
229                 locked.unlockLast = locked.unlockLast.add(periodDuration.mul(periodsToUnlock));
230 
231                 emit Unlock(addrUser, tokenToUnlock);
232                 log(actionUnlock, addrUser, 0, tokenToUnlock, 0, 0);
233             }
234         }
235     }   
236 
237     //从代币合约的调用者地址上转移_value的数量token到的地址_to，并且必须触发Transfer事件
238     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success){
239         require(msg.sender != _to);
240 
241         //检查是否有可以解锁的token
242         _checkUnlock(msg.sender);
243 
244         require(_userMap[msg.sender].tokens >= _value);
245         _userMap[msg.sender].tokens = _userMap[msg.sender].tokens.sub(_value);
246 
247         UserToken storage userTo = _userMap[_to];
248         if(0 == userTo.index){
249             userTo = _addUser(_to);
250         }
251         userTo.tokens = userTo.tokens.add(_value);
252 
253         emit Transfer(msg.sender, _to, _value);
254         log(actionTransfer, msg.sender, _to, _value, 0, 0);
255 
256         success = true;
257     }
258 
259     function transferFrom(address, address, uint256) public whenNotPaused returns (bool success){
260         success = true;
261     }
262 
263     function approve(address, uint256) public whenNotPaused returns (bool success){
264         success = true;
265     }
266 
267     function allowance(address, address) public view returns (uint256 remaining){
268         remaining = 0;
269     }
270 
271     function grant(address _to, uint256 _value, uint256 _duration, uint256 _periods) public whenNotPaused returns (bool success){
272         require(msg.sender != _to);
273 
274         //检查是否有可以解锁的token
275         _checkUnlock(msg.sender);
276 
277         require(_userMap[msg.sender].tokens >= _value);
278         _userMap[msg.sender].tokens = _userMap[msg.sender].tokens.sub(_value);
279         
280         UserToken storage userTo = _userMap[_to];
281         if(0 == userTo.index){
282             userTo = _addUser(_to);
283         }
284 
285         LockedToken memory locked;
286         locked.total = _value;
287         locked.duration = _duration.mul(30 days);
288         // locked.duration = _duration.mul(1 minutes); //for test
289         locked.periods = _periods;
290         locked.balance = _value;
291         locked.unlockLast = now;
292         userTo.lockedTokens.push(locked);
293 
294         emit Grant(msg.sender, _to, _value);
295         log(actionGrant, msg.sender, _to, _value, _duration, _periods);
296 
297         success = true;
298     }
299 
300     function getUserAddr(uint256 _index) public view returns(address addr){
301         require(_index < _userArray.length);
302         addr = _userArray[_index];
303     }
304 
305     function getUserSize() public view returns(uint256 size){
306         size = _userArray.length;
307     }
308 
309 
310     function getLockSize(address addr) public view returns (uint256 len) {
311         UserToken storage user = _userMap[addr];
312         len = user.lockedTokens.length;
313     }
314 
315     function getLock(address addr, uint256 index) public view returns (uint256 total, uint256 duration, uint256 periods, uint256 balance, uint256 unlockLast) {
316         UserToken storage user = _userMap[addr];
317         require(index < user.lockedTokens.length);
318         total = user.lockedTokens[index].total;
319         duration = user.lockedTokens[index].duration;
320         periods = user.lockedTokens[index].periods;
321         balance = user.lockedTokens[index].balance;
322         unlockLast = user.lockedTokens[index].unlockLast;
323     }
324 
325     function getLockInfo(address addr) public view returns (uint256[] totals, uint256[] durations, uint256[] periodses, uint256[] balances, uint256[] unlockLasts) {
326         UserToken storage user = _userMap[addr];
327         uint256 len = user.lockedTokens.length;
328         totals = new uint256[](len);
329         durations = new uint256[](len);
330         periodses = new uint256[](len);
331         balances = new uint256[](len);
332         unlockLasts = new uint256[](len);
333         for (uint index = 0; index < user.lockedTokens.length; index++) {
334             totals[index] = user.lockedTokens[index].total;
335             durations[index] = user.lockedTokens[index].duration;
336             periodses[index] = user.lockedTokens[index].periods;
337             balances[index] = user.lockedTokens[index].balance;
338             unlockLasts[index] = user.lockedTokens[index].unlockLast;
339         }
340     }
341 
342     function log(uint32 action, address from, address to, uint256 _v1, uint256 _v2, uint256 _v3) private {
343         LogEntry memory entry;
344         entry.action = action;
345         entry.time = now;
346         entry.from = from;
347         entry.to = to;
348         entry.v1 = _v1;
349         entry.v2 = _v2;
350         entry.v3 = _v3;
351         _logs.push(entry);
352     }
353 
354     function getLogSize() public view returns(uint256 size){
355         size = _logs.length;
356     }
357 
358     function getLog(uint256 _index) public view returns(uint time, uint32 action, address from, address to, uint256 _v1, uint256 _v2, uint256 _v3){
359         require(_index < _logs.length);
360         require(_index >= 0);
361         LogEntry storage entry = _logs[_index];
362         action = entry.action;
363         time = entry.time;
364         from = entry.from;
365         to = entry.to;
366         _v1 = entry.v1;
367         _v2 = entry.v2;
368         _v3 = entry.v3;
369     }
370 }
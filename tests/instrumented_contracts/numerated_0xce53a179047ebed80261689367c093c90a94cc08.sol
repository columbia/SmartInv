1 pragma solidity ^0.4.16;
2 
3 contract SafeMath {
4     function safeMul(uint a, uint b) pure internal returns (uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function safeSub(uint a, uint b) pure internal returns (uint) {
11         assert(b <= a);
12         return a - b;
13     }
14 
15     function safeAdd(uint a, uint b) pure internal returns (uint) {
16         uint c = a + b;
17         assert(c >= a && c >= b);
18         return c;
19     }
20 }
21 
22 contract EDT is SafeMath {
23 
24     string public name = "EDT";        //  token name
25     string public symbol = "EDT";      //  token symbol
26     uint public decimals = 8;           //  token digit
27 
28     mapping (address => uint) public balanceOf;
29     mapping (address => mapping (address => uint)) public allowance;
30 
31     uint public totalSupply = 0;
32 
33     // 管理账号地址
34     address public owner = 0x0;
35 
36     // 团队地址
37     address private addressTeam = 0xE5fB6dce07BCa4ffc4B79A529a8Ce43A31383BA9;
38 
39     // 锁定信息
40     mapping (address => uint) public lockInfo;
41 
42     // 是否停止销售
43     bool public saleStopped = false;
44 
45     uint constant valueTotal = 15 * 10000 * 10000 * 10 ** 8;  //总量 15亿
46     uint constant valueSale = valueTotal / 100 * 50;  // ICO 50%
47     uint constant valueVip = valueTotal / 100 * 40;   // 私募 40%
48     uint constant valueTeam = valueTotal / 100 * 10;   // 团队 10%
49 
50     uint private totalVip = 0;
51 
52     // 阶段
53     uint private constant BEFORE_SALE = 0;
54     uint private constant IN_SALE = 1;
55     uint private constant FINISHED = 2;
56 
57     // ICO最小以太值
58     uint public minEth = 0.1 ether;
59 
60     // ICO最大以太值
61     uint public maxEth = 1000 ether;
62 
63     // 开始时间 2018-01-01 00:00:00
64     uint public openTime = 1514736000;
65     // 结束时间 2018-01-15 00:00:00
66     uint public closeTime = 1515945600;
67     // 价格
68     uint public price = 8500;
69 
70     // 私募和ICO解锁时间 2018-01-15 00:00:00
71     uint public unlockTime = 1515945600;
72 
73     // 团队解锁时间 2019-01-10 00:00:00
74     uint public unlockTeamTime = 1547049600;
75 
76     // 已卖出代币数量
77     uint public saleQuantity = 0;
78 
79     // 收入的ETH数量
80     uint public ethQuantity = 0;
81 
82     // 提现的代币数量
83     uint public withdrawQuantity = 0;
84 
85 
86     modifier isOwner {
87         assert(owner == msg.sender);
88         _;
89     }
90 
91     modifier validAddress(address _address) {
92         assert(0x0 != _address);
93         _;
94     }
95 
96     modifier validEth {
97         assert(msg.value >= minEth && msg.value <= maxEth);
98         _;
99     }
100 
101     modifier validPeriod {
102         assert(now >= openTime && now < closeTime);
103         _;
104     }
105 
106     modifier validQuantity {
107         assert(valueSale >= saleQuantity);
108         _;
109     }
110 
111 
112     function EDT()
113         public
114     {
115         owner = msg.sender;
116         totalSupply = valueTotal;
117 
118         // ICO
119         balanceOf[this] = valueSale;
120         Transfer(0x0, this, valueSale);
121 
122         // 团队
123         balanceOf[addressTeam] = valueTeam;
124         Transfer(0x0, addressTeam, valueTeam);
125     }
126 
127     function transfer(address _to, uint _value)
128         public
129         validAddress(_to)
130         returns (bool success)
131     {
132         require(balanceOf[msg.sender] >= _value);
133         require(balanceOf[_to] + _value >= balanceOf[_to]);
134         require(validTransfer(msg.sender, _value));
135         balanceOf[msg.sender] -= _value;
136         balanceOf[_to] += _value;
137         Transfer(msg.sender, _to, _value);
138         return true;
139     }
140 
141     function transferInner(address _to, uint _value)
142         private
143         returns (bool success)
144     {
145         balanceOf[this] -= _value;
146         balanceOf[_to] += _value;
147         Transfer(this, _to, _value);
148         return true;
149     }
150 
151 
152     function transferFrom(address _from, address _to, uint _value)
153         public
154         validAddress(_from)
155         validAddress(_to)
156         returns (bool success)
157     {
158         require(balanceOf[_from] >= _value);
159         require(balanceOf[_to] + _value >= balanceOf[_to]);
160         require(allowance[_from][msg.sender] >= _value);
161         require(validTransfer(_from, _value));
162         balanceOf[_to] += _value;
163         balanceOf[_from] -= _value;
164         allowance[_from][msg.sender] -= _value;
165         Transfer(_from, _to, _value);
166         return true;
167     }
168 
169     function approve(address _spender, uint _value)
170         public
171         validAddress(_spender)
172         returns (bool success)
173     {
174         require(_value == 0 || allowance[msg.sender][_spender] == 0);
175         allowance[msg.sender][_spender] = _value;
176         Approval(msg.sender, _spender, _value);
177         return true;
178     }
179 
180     function lock(address _to, uint _value)
181         private
182         validAddress(_to)
183     {
184         require(_value > 0);
185         require(lockInfo[_to] + _value <= balanceOf[_to]);
186         lockInfo[_to] += _value;
187     }
188 
189     function validTransfer(address _from, uint _value)
190         private
191         constant
192         returns (bool)
193     {
194         if (_value == 0)
195             return false;
196 
197         if (_from == addressTeam) {
198             return now >= unlockTeamTime;
199         }
200 
201         if (now >= unlockTime)
202             return true;
203 
204         return lockInfo[_from] + _value <= balanceOf[_from];
205     }
206 
207 
208     function ()
209         public
210         payable
211     {
212         buy();
213     }
214 
215     function buy()
216         public
217         payable
218         validEth        // 以太是否在允许范围
219         validPeriod     // 是否在ICO期间
220         validQuantity   // 代币是否已卖完
221     {
222         uint eth = msg.value;
223 
224         // 计算代币数量
225         uint quantity = eth * price / 10 ** 10;
226 
227         // 是否超出剩余代币
228         uint leftQuantity = safeSub(valueSale, saleQuantity);
229         if (quantity > leftQuantity) {
230             quantity = leftQuantity;
231         }
232 
233         saleQuantity = safeAdd(saleQuantity, quantity);
234         ethQuantity = safeAdd(ethQuantity, eth);
235 
236         // 发送代币
237         require(transferInner(msg.sender, quantity));
238 
239         // 锁定
240         lock(msg.sender, quantity);
241 
242         // 生成日志
243         Buy(msg.sender, eth, quantity);
244 
245     }
246 
247     function stopSale()
248         public
249         isOwner
250         returns (bool)
251     {
252         assert(!saleStopped);
253         saleStopped = true;
254         StopSale();
255         return true;
256     }
257 
258     function getPeriod()
259         public
260         constant
261         returns (uint)
262     {
263         if (saleStopped) {
264             return FINISHED;
265         }
266 
267         if (now < openTime) {
268             return BEFORE_SALE;
269         }
270 
271         if (valueSale == saleQuantity) {
272             return FINISHED;
273         }
274 
275         if (now >= openTime && now < closeTime) {
276             return IN_SALE;
277         }
278 
279         return FINISHED;
280     }
281 
282 
283     function withdraw(uint amount)
284         public
285         isOwner
286     {
287         uint period = getPeriod();
288         require(period == FINISHED);
289 
290         require(this.balance >= amount);
291         msg.sender.transfer(amount);
292     }
293 
294     function withdrawToken(uint amount)
295         public
296         isOwner
297     {
298         uint period = getPeriod();
299         require(period == FINISHED);
300 
301         withdrawQuantity += safeAdd(withdrawQuantity, amount);
302         require(transferInner(msg.sender, amount));
303     }
304 
305     function setVipInfo(address _vip, uint _value)
306         public
307         isOwner
308         validAddress(_vip)
309     {
310         require(_value > 0);
311         require(_value + totalVip <= valueVip);
312 
313         balanceOf[_vip] += _value;
314         Transfer(0x0, _vip, _value);
315         lock(_vip, _value);
316     }
317 
318     event Transfer(address indexed _from, address indexed _to, uint _value);
319     event Approval(address indexed _owner, address indexed _spender, uint _value);
320 
321     event Buy(address indexed sender, uint eth, uint token);
322     event StopSale();
323 }
1 pragma solidity ^0.4.18;
2 
3 
4 contract owned {
5     address public owner;
6     address public ownerCandidate;
7 
8     function owned() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         assert(owner == msg.sender);
14         _;
15     }
16 
17     modifier onlyOwnerCandidate() {
18         assert(msg.sender == ownerCandidate);
19         _;
20     }
21 
22     function transferOwnership(address candidate) external onlyOwner {
23         ownerCandidate = candidate;
24     }
25 
26     function acceptOwnership() external onlyOwnerCandidate {
27         owner = ownerCandidate;
28         ownerCandidate = 0x0;
29     }
30 }
31 
32 
33 
34 contract SafeMath {
35     function safeMul(uint a, uint b) pure internal returns (uint) {
36         uint c = a * b;
37         assert(a == 0 || c / a == b);
38         return c;
39     }
40 
41     function safeDiv(uint a, uint b) pure internal returns (uint) {
42         uint c = a / b;
43         assert(b == 0);
44         return c;
45     }
46 
47     function safeSub(uint a, uint b) pure internal returns (uint) {
48         assert(b <= a);
49         return a - b;
50     }
51 
52     function safeAdd(uint a, uint b) pure internal returns (uint) {
53         uint c = a + b;
54         assert(c >= a && c >= b);
55         return c;
56     }
57 }
58 
59 
60 contract VAAToken is SafeMath, owned {
61 
62     string public name = "VAAToken";        //  token name
63     string public symbol = "VAAT";      //  token symbol
64     uint public decimals = 8;           //  token digit
65 
66     mapping (address => uint) public balanceOf;
67     mapping (address => mapping (address => uint)) public allowance;
68 
69     uint public totalSupply = 0;
70 
71 
72     // 团队地址
73     address private addressTeam = 0x5b1FcBA12b4757549bf5d0550af253DE5E0F73c5;
74 
75     // 基金地址
76     address private addressFund = 0xA703356488F7335269e5860ca41f787dFF50b76C;
77 
78     // 推广钱包
79     address private addressPopular = 0x1db0304A3f2a861e7Ab8B7305AF1dC1ee4c3e94d;
80 
81     // 私募钱包
82     address private addressVip = 0x6e41aA4d64F9f4a190a9AF2292F815259BAef65c;
83 
84     //持仓总量
85     uint constant valueTotal = 10 * 10000 * 10000 * 10 ** 8;  //总量 10E
86     uint constant valueTeam = valueTotal / 100 * 20;   // 团队 20% 2E
87     uint constant valueFund = valueTotal / 100 * 30; //基金 30% 3E
88     uint constant valuePopular = valueTotal / 100 * 20; //平台新用户奖励及推广营销2E
89     uint constant valueSale = valueTotal / 100 * 20;  // ICO 20% 2E
90     uint constant valueVip = valueTotal / 100 * 10;   // 私募 10% 1E
91 
92 
93     // 是否停止销售
94     bool public saleStopped = false;
95 
96     // 阶段
97     uint private constant BEFORE_SALE = 0;
98     uint private constant IN_SALE = 1;
99     uint private constant FINISHED = 2;
100 
101     // ICO最小以太值
102     uint public minEth = 0.1 ether;
103 
104     // ICO最大以太值
105     uint public maxEth = 1000 ether;
106 
107     // 开始时间 2018-03-29 00:00:00
108     uint public openTime = 1522252800;
109     // 结束时间 2018-06-01 00:00:00
110     uint public closeTime = 1527782400;
111 
112     // 价格
113     uint public price = 3500;
114 
115     // 已卖出代币数量
116     uint public saleQuantity = 0;
117 
118     // 收入的ETH数量
119     uint public ethQuantity = 0;
120 
121     // 提现的代币数量
122     uint public withdrawQuantity = 0;
123 
124 
125     modifier validAddress(address _address) {
126         assert(0x0 != _address);
127         _;
128     }
129 
130     modifier validEth {
131         assert(msg.value >= minEth && msg.value <= maxEth);
132         _;
133     }
134 
135     modifier validPeriod {
136         assert(now >= openTime && now < closeTime);
137         _;
138     }
139 
140     modifier validQuantity {
141         assert(valueSale >= saleQuantity);
142         _;
143     }
144 
145     modifier validStatue {
146         assert(saleStopped == false);
147         _;
148     }
149 
150     function setOpenTime(uint newOpenTime) public onlyOwner {
151         openTime = newOpenTime;
152     }
153 
154     function setCloseTime(uint newCloseTime) public onlyOwner {
155         closeTime = newCloseTime;
156     }
157 
158     function VAAToken()
159         public
160     {
161         owner = msg.sender;
162         totalSupply = valueTotal;
163 
164         // ICO
165         balanceOf[this] = valueSale;
166         Transfer(0x0, this, valueSale);
167 
168         // Simu
169         balanceOf[addressVip] = valueVip;
170         Transfer(0x0, addressVip, valueVip);
171 
172         // Found
173         balanceOf[addressFund] = valueFund;
174         Transfer(0x0, addressFund, valueFund);
175 
176         // valuePopular
177         balanceOf[addressPopular] = valuePopular;
178         Transfer(0x0, addressPopular, valuePopular);
179 
180         // 团队
181         balanceOf[addressTeam] = valueTeam;
182         Transfer(0x0, addressTeam, valueTeam);
183     }
184 
185     function transfer(address _to, uint _value)
186         public
187         validAddress(_to)
188         returns (bool success)
189     {
190         require(balanceOf[msg.sender] >= _value);
191         require(balanceOf[_to] + _value >= balanceOf[_to]);
192         require(validTransfer(_value));
193         balanceOf[msg.sender] -= _value;
194         balanceOf[_to] += _value;
195         Transfer(msg.sender, _to, _value);
196         return true;
197     }
198 
199     function transferInner(address _to, uint _value)
200         private
201         returns (bool success)
202     {
203         balanceOf[this] -= _value;
204         balanceOf[_to] += _value;
205         Transfer(this, _to, _value);
206         return true;
207     }
208 
209 
210     function transferFrom(address _from, address _to, uint _value)
211         public
212         validAddress(_from)
213         validAddress(_to)
214         returns (bool success)
215     {
216         require(balanceOf[_from] >= _value);
217         require(balanceOf[_to] + _value >= balanceOf[_to]);
218         require(allowance[_from][msg.sender] >= _value);
219         require(validTransfer(_value));
220         balanceOf[_to] += _value;
221         balanceOf[_from] -= _value;
222         allowance[_from][msg.sender] -= _value;
223         Transfer(_from, _to, _value);
224         return true;
225     }
226 
227     //批量转账
228     function batchtransfer(address[] _to, uint256[] _amount) public returns(bool success) {
229         for(uint i = 0; i < _to.length; i++){
230             require(transfer(_to[i], _amount[i]));
231         }
232         return true;
233     }
234 
235     function approve(address _spender, uint _value)
236         public
237         validAddress(_spender)
238         returns (bool success)
239     {
240         require(_value == 0 || allowance[msg.sender][_spender] == 0);
241         allowance[msg.sender][_spender] = _value;
242         Approval(msg.sender, _spender, _value);
243         return true;
244     }
245 
246     function validTransfer(uint _value)
247         pure private
248         returns (bool)
249     {
250         if (_value == 0)
251             return false;
252 
253         return true;
254     }
255 
256     function ()
257         public
258         payable
259     {
260         buy();
261     }
262 
263     function buy()
264         public
265         payable
266         validEth        // 以太是否在允许范围
267         validPeriod     // 是否在ICO期间
268         validQuantity   // 代币是否已卖完
269         validStatue     // 售卖是否已经主动结束
270     {
271         uint eth = msg.value;
272 
273         // 计算代币数量
274         uint quantity = eth * price / 10 ** 10;
275 
276         // 是否超出剩余代币
277         uint leftQuantity = safeSub(valueSale, saleQuantity);
278         if (quantity > leftQuantity) {
279             quantity = leftQuantity;
280         }
281 
282         saleQuantity = safeAdd(saleQuantity, quantity);
283         ethQuantity = safeAdd(ethQuantity, eth);
284 
285         // 发送代币
286         require(transferInner(msg.sender, quantity));
287 
288         // 生成日志
289         Buy(msg.sender, eth, quantity);
290 
291     }
292 
293     function stopSale()
294         public
295         onlyOwner
296         returns (bool)
297     {
298         assert(!saleStopped);
299         saleStopped = true;
300         StopSale();
301         return true;
302     }
303 
304     function getPeriod()
305         public
306         constant
307         returns (uint)
308     {
309         if (saleStopped) {
310             return FINISHED;
311         }
312 
313         if (now < openTime) {
314             return BEFORE_SALE;
315         }
316 
317         if (valueSale == saleQuantity) {
318             return FINISHED;
319         }
320 
321         if (now >= openTime && now < closeTime) {
322             return IN_SALE;
323         }
324 
325         return FINISHED;
326     }
327 
328     //从合约提Eth
329     function withdraw(uint amount)
330         public
331         onlyOwner
332     {
333         uint period = getPeriod();
334         require(period == FINISHED);
335 
336         require(this.balance >= amount);
337         msg.sender.transfer(amount);
338     }
339 
340     // 从合约提token 一定要公募结束才可以提
341     function withdrawToken(uint amount)
342         public
343         onlyOwner
344     {
345         uint period = getPeriod();
346         require(period == FINISHED);
347 
348         withdrawQuantity += safeAdd(withdrawQuantity, amount);
349         require(transferInner(msg.sender, amount));
350     }
351 
352 
353 
354     event Transfer(address indexed _from, address indexed _to, uint _value);
355     event Approval(address indexed _owner, address indexed _spender, uint _value);
356     event Buy(address indexed sender, uint eth, uint token);
357     event StopSale();
358 }
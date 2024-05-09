1 pragma solidity 0.4.20;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 /**
6  * owned 是一个管理者
7  */
8 contract owned {
9     address public owner;
10 
11     /**
12      * 初台化构造函数
13      */
14     function owned () public {
15         owner = msg.sender;
16     }
17 
18     /**
19      * 判断当前合约调用者是否是管理员
20      */
21     modifier onlyOwner {
22         require (msg.sender == owner);
23         _;
24     }
25 
26     /**
27      * 指派一个新的管理员
28      * @param  newOwner address 新的管理员帐户地址
29      */
30     function transferOwnership(address newOwner) onlyOwner public {
31         if (newOwner != address(0)) {
32         owner = newOwner;
33       }
34     }
35 }
36 
37 /**
38  * @title 基础版的代币合约
39  */
40 contract token {
41     /* 公共变量 */
42     string public site = 'WWW.CBANK.IN'; // 合约银行 www.contractbank.cn 
43     string public name; //代币名称
44     string public symbol; //代币符号比如'$'
45     uint8 public decimals = 18;  //代币单位，展示的小数点后面多少个0,和以太币一样后面是是18个0
46     uint256 public totalSupply; //代币总量
47 
48     /*记录所有余额的映射*/
49     mapping (address => uint256) public balanceOf;
50     mapping (address => mapping (address => uint256)) public allowance;
51 
52     /* 在区块链上创建一个事件，用以通知客户端*/
53     event Transfer(address indexed from, address indexed to, uint256 value);  //转帐通知事件
54     event Burn(address indexed from, uint256 value);  //减去用户余额事件
55 
56     /* 初始化合约，并且把初始的所有代币都给这合约的创建者
57      * @param initialSupply 代币的总数
58      * @param tokenName 代币名称
59      * @param tokenSymbol 代币符号
60      */
61     function token(uint256 initialSupply, string tokenName, string tokenSymbol) public {
62 
63         //初始化总量
64         totalSupply = initialSupply * 10 ** uint256(decimals);    //以太币是10^18，后面18个0，所以默认decimals是18
65 
66         //给指定帐户初始化代币总量，初始化用于奖励合约创建者
67         balanceOf[msg.sender] = totalSupply;
68         //balanceOf[this] = totalSupply;
69 
70         name = tokenName;
71         symbol = tokenSymbol;
72 
73     }
74 
75 
76     /**
77      * 私有方法从一个帐户发送给另一个帐户代币
78      * @param  _from address 发送代币的地址
79      * @param  _to address 接受代币的地址
80      * @param  _value uint256 接受代币的数量
81      */
82     function _transfer(address _from, address _to, uint256 _value) internal {
83 
84       //避免转帐的地址是0x0
85       require(_to != 0x0);
86 
87       //检查发送者是否拥有足够余额
88       require(balanceOf[_from] >= _value);
89 
90       //检查是否溢出
91       require(balanceOf[_to] + _value > balanceOf[_to]);
92 
93       //保存数据用于后面的判断
94       uint previousBalances = balanceOf[_from] + balanceOf[_to];
95 
96       //从发送者减掉发送额
97       balanceOf[_from] -= _value;
98 
99       //给接收者加上相同的量
100       balanceOf[_to] += _value;
101 
102       //通知任何监听该交易的客户端
103       Transfer(_from, _to, _value);
104 
105       //判断买、卖双方的数据是否和转换前一致
106       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
107 
108     }
109 
110     /**
111      * 从主帐户合约调用者发送给别人代币
112      * @param  _to address 接受代币的地址
113      * @param  _value uint256 接受代币的数量
114      */
115     function transfer(address _to, uint256 _value) public {
116         _transfer(msg.sender, _to, _value);
117     }
118 
119     /**
120      * 从某个指定的帐户中，向另一个帐户发送代币
121      *
122      * 调用过程，会检查设置的允许最大交易额
123      *
124      * @param  _from address 发送者地址
125      * @param  _to address 接受者地址
126      * @param  _value uint256 要转移的代币数量
127      * @return success        是否交易成功
128      */
129     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
130         //检查发送者是否拥有足够余额
131         require(_value <= allowance[_from][msg.sender]);   // Check allowance
132 
133         allowance[_from][msg.sender] -= _value;
134 
135         _transfer(_from, _to, _value);
136 
137         return true;
138     }
139 
140     /**
141      * 设置帐户允许支付的最大金额
142      *
143      * 一般在智能合约的时候，避免支付过多，造成风险
144      *
145      * @param _spender 帐户地址
146      * @param _value 金额
147      */
148     function approve(address _spender, uint256 _value) public returns (bool success) {
149         allowance[msg.sender][_spender] = _value;
150         return true;
151     }
152 
153     /**
154      * 设置帐户允许支付的最大金额
155      *
156      * 一般在智能合约的时候，避免支付过多，造成风险，加入时间参数，可以在 tokenRecipient 中做其他操作
157      *
158      * @param _spender 帐户地址
159      * @param _value 金额
160      * @param _extraData 操作的时间
161      */
162     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
163         tokenRecipient spender = tokenRecipient(_spender);
164         if (approve(_spender, _value)) {
165             spender.receiveApproval(msg.sender, _value, this, _extraData);
166             return true;
167         }
168     }
169 
170     /**
171      * 减少代币调用者的余额
172      *
173      * 操作以后是不可逆的
174      *
175      * @param _value 要删除的数量
176      */
177     function burn(uint256 _value) public returns (bool success) {
178         //检查帐户余额是否大于要减去的值
179         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
180 
181         //给指定帐户减去余额
182         balanceOf[msg.sender] -= _value;
183 
184         //代币问题做相应扣除
185         totalSupply -= _value;
186 
187         Burn(msg.sender, _value);
188         return true;
189     }
190 
191     /**
192      * 删除帐户的余额（含其他帐户）
193      *
194      * 删除以后是不可逆的
195      *
196      * @param _from 要操作的帐户地址
197      * @param _value 要减去的数量
198      */
199     function burnFrom(address _from, uint256 _value) public returns (bool success) {
200 
201         //检查帐户余额是否大于要减去的值
202         require(balanceOf[_from] >= _value);
203 
204         //检查 其他帐户 的余额是否够使用
205         require(_value <= allowance[_from][msg.sender]);
206 
207         //减掉代币
208         balanceOf[_from] -= _value;
209         allowance[_from][msg.sender] -= _value;
210 
211         //更新总量
212         totalSupply -= _value;
213         Burn(_from, _value);
214         return true;
215     }
216 
217 
218 
219     /**
220      * 匿名方法，预防有人向这合约发送以太币
221      */
222     /*function() {
223         //return;     // Prevents accidental sending of ether
224     }*/
225 }
226 
227 /**
228  * @title 高级版代币
229  * 增加冻结用户、挖矿、根据指定汇率购买(售出)代币价格的功能
230  */
231 contract MyAdvancedToken is owned, token {
232 
233     //卖出的汇率,一个代币，可以卖出多少个以太币，单位是wei
234     uint256 public sellPrice;
235 
236     //买入的汇率,1个以太币，可以买几个代币
237     uint256 public buyPrice;
238 
239     //是否冻结帐户的列表
240     mapping (address => bool) public frozenAccount;
241 
242     //定义一个事件，当有资产被冻结的时候，通知正在监听事件的客户端
243     event FrozenFunds(address target, bool frozen);
244 
245 
246     /*初始化合约，并且把初始的所有的令牌都给这合约的创建者
247      * @param initialSupply 所有币的总数
248      * @param tokenName 代币名称
249      * @param tokenSymbol 代币符号
250      * @param centralMinter 是否指定其他帐户为合约所有者,为0是去中心化
251      */
252     function MyAdvancedToken (
253       uint256 initialSupply,
254       string tokenName,
255       string tokenSymbol,
256       address centralMinter
257     ) token (initialSupply, tokenName, tokenSymbol) public {
258 
259         //设置合约的管理者
260         if(centralMinter != 0 ) owner = centralMinter;
261 
262         sellPrice = 2;     //设置1个单位的代币(单位是wei)，能够卖出2个以太币
263         buyPrice = 4;      //设置1个以太币，可以买0.25个代币
264     }
265 
266 
267     /**
268      * 私有方法，从指定帐户转出余额
269      * @param  _from address 发送代币的地址
270      * @param  _to address 接受代币的地址
271      * @param  _value uint256 接受代币的数量
272      */
273     function _transfer(address _from, address _to, uint _value) internal {
274 
275         //避免转帐的地址是0x0
276         require (_to != 0x0);
277 
278         //检查发送者是否拥有足够余额
279         require (balanceOf[_from] > _value);
280 
281         //检查是否溢出
282         require (balanceOf[_to] + _value > balanceOf[_to]);
283 
284         //检查 冻结帐户
285         require(!frozenAccount[_from]);
286         require(!frozenAccount[_to]);
287 
288 
289 
290         //从发送者减掉发送额
291         balanceOf[_from] -= _value;
292 
293         //给接收者加上相同的量
294         balanceOf[_to] += _value;
295 
296         //通知任何监听该交易的客户端
297         Transfer(_from, _to, _value);
298 
299     }
300 
301     /**
302      * 合约拥有者，可以为指定帐户创造一些代币
303      * @param  target address 帐户地址
304      * @param  mintedAmount uint256 增加的金额(单位是wei)
305      */
306     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
307 
308         //给指定地址增加代币，同时总量也相加
309         balanceOf[target] += mintedAmount;
310         totalSupply += mintedAmount;
311 
312 
313         Transfer(0, this, mintedAmount);
314         Transfer(this, target, mintedAmount);
315     }
316 
317     /**
318      * 增加冻结帐户名称
319      *
320      * 你可能需要监管功能以便你能控制谁可以/谁不可以使用你创建的代币合约
321      *
322      * @param  target address 帐户地址
323      * @param  freeze bool    是否冻结
324      */
325     function freezeAccount(address target, bool freeze) onlyOwner public {
326         frozenAccount[target] = freeze;
327         FrozenFunds(target, freeze);
328     }
329 
330     /**
331      * 设置买卖价格
332      *
333      * 如果你想让ether(或其他代币)为你的代币进行背书,以便可以市场价自动化买卖代币,我们可以这么做。如果要使用浮动的价格，也可以在这里设置
334      *
335      * @param newSellPrice 新的卖出价格
336      * @param newBuyPrice 新的买入价格
337      */
338     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
339         sellPrice = newSellPrice;
340         buyPrice = newBuyPrice;
341     }
342 
343     /**
344      * 使用以太币购买代币
345      */
346     function buy() payable public {
347       uint amount = msg.value / buyPrice;
348 
349       _transfer(this, msg.sender, amount);
350     }
351 
352     /**
353      * @dev 卖出代币
354      * @return 要卖出的数量(单位是wei)
355      */
356     function sell(uint256 amount) public {
357 
358         //检查合约的余额是否充足
359         require(this.balance >= amount * sellPrice);
360 
361         _transfer(msg.sender, this, amount);
362 
363         msg.sender.transfer(amount * sellPrice);
364     }
365 }
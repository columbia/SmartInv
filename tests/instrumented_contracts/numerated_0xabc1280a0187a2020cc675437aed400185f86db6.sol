1 pragma solidity ^0.4.20;
2 
3 //---------------------------------------------------------
4 //  增强版的代币合约 V 0.9
5 //                                       WangYi 2018-05-07
6 //---------------------------------------------------------
7 contract ERC20ext
8 {
9   // stand
10   function totalSupply() public constant returns (uint supply);
11   function balanceOf( address who ) public constant returns (uint value);
12   function allowance( address owner, address spender ) public constant returns (uint _allowance);
13 
14   function transfer( address to, uint value) public returns (bool ok);
15   function transferFrom( address from, address to, uint value) public returns (bool ok);
16   function approve( address spender, uint value ) public returns (bool ok);
17 
18   event Transfer( address indexed from, address indexed to, uint value);
19   event Approval( address indexed owner, address indexed spender, uint value);
20 
21   // extand
22   function postMessage(address dst, uint wad,string data) public returns (bool ok);
23   function appointNewCFO(address newCFO) public returns (bool ok);
24 
25   function melt(address dst, uint256 wad) public returns (bool ok);
26   function mint(address dst, uint256 wad) public returns (bool ok);
27   function freeze(address dst, bool flag) public returns (bool ok);
28 
29   event MeltEvent(address indexed dst, uint256 wad);
30   event MintEvent(address indexed dst, uint256 wad);
31   event FreezeEvent(address indexed dst, bool flag);
32 }
33 
34 //---------------------------------------------------------
35 // SafeMath 是一个安全数字运算的合约
36 //---------------------------------------------------------
37 contract SafeMath 
38 {
39   /**
40   * @dev Multiplies two numbers, throws on overflow.
41   */
42   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) 
43   {
44     if (a == 0) {
45       return 0;
46     }
47     c = a * b;
48     assert(c / a == b);
49     return c;
50   }
51 
52   /**
53   * @dev Integer division of two numbers, truncating the quotient.
54   */
55   function div(uint256 a, uint256 b) internal pure returns (uint256) 
56   {
57     // assert(b > 0); // Solidity automatically throws when dividing by 0
58     // uint256 c = a / b;
59     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60     return a / b;
61   }
62 
63   /**
64   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
65   */
66   function sub(uint256 a, uint256 b) internal pure returns (uint256) 
67   {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   /**
73   * @dev Adds two numbers, throws on overflow.
74   */
75   function add(uint256 a, uint256 b) internal pure returns (uint256 c) 
76   {
77     c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 //---------------------------------------------------------
84 // sacToken 是一个增强版ERC20合约
85 //---------------------------------------------------------
86 contract sacToken is ERC20ext,SafeMath
87 {
88   string public name;
89   string public symbol;
90   uint8  public decimals = 18;
91 
92   address _cfo;
93   uint256 _supply;
94 
95   //帐户的余额列表
96   mapping (address => uint256) _balances;
97 
98   //帐户的转账限额
99   mapping (address => mapping (address => uint256)) _allowance;
100 
101   //帐户的资金冻结
102   mapping (address => bool) public _frozen;
103 
104   //-----------------------------------------------
105   // 初始化合约，并把所有代币都给CFO
106   //-----------------------------------------------
107   //   @param initialSupply 发行总量
108   //   @param tokenName     代币名称
109   //   @param tokenSymbol   代币符号
110   //-----------------------------------------------
111   function sacToken(uint256 initialSupply,string tokenName,string tokenSymbol) public
112   {
113     _cfo    = msg.sender;
114     _supply = initialSupply * 10 ** uint256(decimals);
115     _balances[_cfo] = _supply;
116 
117     name   = tokenName;
118     symbol = tokenSymbol;
119   }
120 
121   //-----------------------------------------------
122   // 判断合约调用者是否 CFO
123   //-----------------------------------------------
124   modifier onlyCFO()
125   {
126     require(msg.sender == _cfo);
127     _;
128   }
129 
130 
131   //-----------------------------------------------
132   // 获取货币供应量
133   //-----------------------------------------------
134   function totalSupply() public constant returns (uint256)
135   {
136     return _supply;
137   }
138 
139   //-----------------------------------------------
140   // 查询账户余额
141   //-----------------------------------------------
142   // @param  src 帐户地址
143   //-----------------------------------------------
144   function balanceOf(address src) public constant returns (uint256)
145   {
146     return _balances[src];
147   }
148 
149   //-----------------------------------------------
150   // 查询账户转账限额
151   //-----------------------------------------------
152   // @param  src 来源帐户地址
153   // @param  dst 目标帐户地址
154   //-----------------------------------------------
155   function allowance(address src, address dst) public constant returns (uint256)
156   {
157     return _allowance[src][dst];
158   }
159 
160   //-----------------------------------------------
161   // 账户转账
162   //-----------------------------------------------
163   // @param  dst 目标帐户地址
164   // @param  wad 转账金额
165   //-----------------------------------------------
166   function transfer(address dst, uint wad) public returns (bool)
167   {
168     //检查冻结帐户
169     require(!_frozen[msg.sender]);
170     require(!_frozen[dst]);
171 
172     //检查帐户余额
173     require(_balances[msg.sender] >= wad);
174 
175     _balances[msg.sender] = sub(_balances[msg.sender],wad);
176     _balances[dst]        = add(_balances[dst], wad);
177 
178     Transfer(msg.sender, dst, wad);
179 
180     return true;
181   }
182 
183   //-----------------------------------------------
184   // 账户转账带检查限额
185   //-----------------------------------------------
186   // @param  src 来源帐户地址
187   // @param  dst 目标帐户地址
188   // @param  wad 转账金额
189   //-----------------------------------------------
190   function transferFrom(address src, address dst, uint wad) public returns (bool)
191   {
192     //检查冻结帐户
193     require(!_frozen[msg.sender]);
194     require(!_frozen[dst]);
195 
196     //检查帐户余额
197     require(_balances[src] >= wad);
198 
199     //检查帐户限额
200     require(_allowance[src][msg.sender] >= wad);
201 
202     _allowance[src][msg.sender] = sub(_allowance[src][msg.sender],wad);
203 
204     _balances[src] = sub(_balances[src],wad);
205     _balances[dst] = add(_balances[dst],wad);
206 
207     //转账事件
208     Transfer(src, dst, wad);
209 
210     return true;
211   }
212 
213   //-----------------------------------------------
214   // 设置转账限额
215   //-----------------------------------------------
216   // @param  dst 目标帐户地址
217   // @param  wad 限制金额
218   //-----------------------------------------------
219   function approve(address dst, uint256 wad) public returns (bool)
220   {
221     _allowance[msg.sender][dst] = wad;
222 
223     //设置事件
224     Approval(msg.sender, dst, wad);
225     return true;
226   }
227 
228   //-----------------------------------------------
229   // 账户转账带附加数据
230   //-----------------------------------------------
231   // @param  dst  目标帐户地址
232   // @param  wad  限制金额
233   // @param  data 附加数据
234   //-----------------------------------------------
235   function postMessage(address dst, uint wad,string data) public returns (bool)
236   {
237     return transfer(dst,wad);
238   }
239 
240   //-----------------------------------------------
241   // 任命新的CFO
242   //-----------------------------------------------
243   // @param  newCFO 新的CFO帐户地址
244   //-----------------------------------------------
245   function appointNewCFO(address newCFO) onlyCFO public returns (bool)
246   {
247     if (newCFO != _cfo)
248     {
249       _cfo = newCFO;
250       return true;
251     }
252     else
253     {
254       return false;
255     }
256   }
257 
258   //-----------------------------------------------
259   // 冻结帐户
260   //-----------------------------------------------
261   // @param  dst  目标帐户地址
262   // @param  flag 冻结
263   //-----------------------------------------------
264   function freeze(address dst, bool flag) onlyCFO public returns (bool)
265   {
266     _frozen[dst] = flag;
267 
268     //冻结帐户事件
269     FreezeEvent(dst, flag);
270     return true;
271   }
272 
273   //-----------------------------------------------
274   // 铸造代币
275   //-----------------------------------------------
276   // @param  dst  目标帐户地址
277   // @param  wad  铸造金额
278   //-----------------------------------------------
279   function mint(address dst, uint256 wad) onlyCFO public returns (bool)
280   {
281     //目标帐户地址铸造代币,同时更新总量
282     _balances[dst] = add(_balances[dst],wad);
283     _supply        = add(_supply,wad);
284 
285     //铸造代币事件
286     MintEvent(dst, wad);
287     return true;
288   }
289 
290   //-----------------------------------------------
291   // 销毁代币
292   //-----------------------------------------------
293   // @param  dst  目标帐户地址
294   // @param  wad  销毁金额
295   //-----------------------------------------------
296   function melt(address dst, uint256 wad) onlyCFO public returns (bool)
297   {
298     //检查帐户余额
299     require(_balances[dst] >= wad);
300 
301     //销毁目标帐户地址代币,同时更新总量
302     _balances[dst] = sub(_balances[dst],wad);
303     _supply        = sub(_supply,wad);
304 
305     //销毁代币事件
306     MeltEvent(dst, wad);
307     return true;
308   }
309 }
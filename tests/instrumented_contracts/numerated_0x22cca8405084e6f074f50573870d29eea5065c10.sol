1 //---------------------------------------------------------
2 //      _  _____    ____ ___ ___ _   _
3 //     / \|_   _|  / ___/ _ \_ _| \ | |
4 //    / _ \ | |   | |  | | | | ||  \| |
5 //   / ___ \| |   | |__| |_| | || |\  |
6 //  /_/   \_\_|    \____\___/___|_| \_|
7 //
8 //---------------------------------------------------------
9 //  新增  1、setCtrlToken
10 //        2、approveAuto
11 //  用于BANCOR自动批准代币的转账限额
12 //---------------------------------------------------------
13 
14 pragma solidity ^0.4.25;
15 
16 contract ERC20ext
17 {
18     // stand
19     function totalSupply() public constant returns (uint supply);
20     function balanceOf(address who) public constant returns (uint value);
21     function allowance(address owner, address spender) public constant returns (uint _allowance);
22 
23     function transfer(address to, uint value) public returns (bool ok);
24     function transferFrom(address from, address to, uint value) public returns (bool ok);
25     function approve(address spender, uint value) public returns (bool ok);
26 
27     event Transfer(address indexed from, address indexed to, uint value);
28     event Approval(address indexed owner, address indexed spender, uint value);
29 
30     // extand
31     function setCtrlToken(address newToken) public returns (bool ok);
32     function approveAuto(address spender, uint value ) public returns (bool ok);
33 
34     function appointNewCFO(address newCFO) public returns (bool ok);
35     function melt(address dst, uint256 wad) public returns (bool ok);
36     function mint(address dst, uint256 wad) public returns (bool ok);
37     function freeze(address dst, bool flag) public returns (bool ok);
38 
39     event MeltEvent(address indexed dst, uint256 wad);
40     event MintEvent(address indexed dst, uint256 wad);
41     event FreezeEvent(address indexed dst, bool flag);
42 }
43 
44 //---------------------------------------------------------
45 // SafeMath 是一个安全数字运算的合约
46 //---------------------------------------------------------
47 contract SafeMath
48 {
49     /**
50     * @dev Multiplies two numbers, throws on overflow.
51     */
52     function mul(uint256 a, uint256 b) internal pure returns (uint256 c)
53     {
54         if (a == 0) {
55             return 0;
56         }
57         c = a * b;
58         assert(c / a == b);
59         return c;
60     }
61 
62     /**
63     * @dev Integer division of two numbers, truncating the quotient.
64     */
65     function div(uint256 a, uint256 b) internal pure returns (uint256)
66     {
67         // assert(b > 0); // Solidity automatically throws when dividing by 0
68         // uint256 c = a / b;
69         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70         return a / b;
71     }
72 
73     /**
74     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75     */
76     function sub(uint256 a, uint256 b) internal pure returns (uint256)
77     {
78         assert(b <= a);
79         return a - b;
80     }
81 
82     /**
83     * @dev Adds two numbers, throws on overflow.
84     */
85     function add(uint256 a, uint256 b) internal pure returns (uint256 c)
86     {
87         c = a + b;
88         assert(c >= a);
89         return c;
90     }
91 }
92 
93 //---------------------------------------------------------
94 // atToken 是一个增强版ERC20合约
95 //---------------------------------------------------------
96 contract atToken is ERC20ext,SafeMath
97 {
98     string public name;
99     string public symbol;
100     uint8  public decimals = 18;
101 
102     // 用于设置批准的TOKEN地址
103     address _token;
104 
105     address _cfo;
106     uint256 _supply;
107 
108     //帐户的余额列表
109     mapping (address => uint256) _balances;
110 
111     //帐户的转账限额
112     mapping (address => mapping (address => uint256)) _allowance;
113 
114     //帐户的资金冻结
115     mapping (address => bool) public _frozen;
116 
117     //-----------------------------------------------
118     // 初始化合约，并把所有代币都给CFO
119     //-----------------------------------------------
120     //   @param initialSupply 发行总量
121     //   @param tokenName     代币名称
122     //   @param tokenSymbol   代币符号
123     //-----------------------------------------------
124     constructor(uint256 initialSupply,string tokenName,string tokenSymbol) public
125     {
126         // validate input
127         require(bytes(tokenName).length > 0 && bytes(tokenSymbol).length > 0);
128 
129         _token  = msg.sender;
130         _cfo    = msg.sender;
131 
132         _supply = initialSupply * 10 ** uint256(decimals);
133         _balances[_cfo] = _supply;
134 
135         name   = tokenName;
136         symbol = tokenSymbol;
137     }
138 
139     //-----------------------------------------------
140     // 判断合约调用者是否 CFO
141     //-----------------------------------------------
142     modifier onlyCFO()
143     {
144         require(msg.sender == _cfo);
145         _;
146     }
147 
148     //-----------------------------------------------
149     // 判断合约调用者是否 Ctrl Token
150     //-----------------------------------------------
151     modifier onlyCtrlToken()
152     {
153         require(msg.sender == _token);
154         _;
155     }
156 
157     //-----------------------------------------------
158     // 获取货币供应量
159     //-----------------------------------------------
160     function totalSupply() public constant returns (uint256)
161     {
162         return _supply;
163     }
164 
165     //-----------------------------------------------
166     // 查询账户余额
167     //-----------------------------------------------
168     // @param  src 帐户地址
169     //-----------------------------------------------
170     function balanceOf(address src) public constant returns (uint256)
171     {
172         return _balances[src];
173     }
174 
175     //-----------------------------------------------
176     // 查询账户转账限额
177     //-----------------------------------------------
178     // @param  src 来源帐户地址
179     // @param  dst 目标帐户地址
180     //-----------------------------------------------
181     function allowance(address src, address dst) public constant returns (uint256)
182     {
183         return _allowance[src][dst];
184     }
185 
186     //-----------------------------------------------
187     // 账户转账
188     //-----------------------------------------------
189     // @param  dst 目标帐户地址
190     // @param  wad 转账金额
191     //-----------------------------------------------
192     function transfer(address dst, uint wad) public returns (bool)
193     {
194         //检查冻结帐户
195         require(!_frozen[msg.sender]);
196         require(!_frozen[dst]);
197 
198         //检查帐户余额
199         require(_balances[msg.sender] >= wad);
200 
201         _balances[msg.sender] = sub(_balances[msg.sender],wad);
202         _balances[dst]        = add(_balances[dst], wad);
203 
204         emit Transfer(msg.sender, dst, wad);
205 
206         return true;
207     }
208 
209 
210     //-----------------------------------------------
211     // 账户转账带检查限额
212     //-----------------------------------------------
213     // @param  src 来源帐户地址
214     // @param  dst 目标帐户地址
215     // @param  wad 转账金额
216     //-----------------------------------------------
217     function transferFrom(address src, address dst, uint wad) public returns (bool)
218     {
219         //检查冻结帐户
220         require(!_frozen[msg.sender]);
221         require(!_frozen[dst]);
222 
223         //检查帐户余额
224         require(_balances[src] >= wad);
225 
226         //检查帐户限额
227         require(_allowance[src][msg.sender] >= wad);
228 
229         _allowance[src][msg.sender] = sub(_allowance[src][msg.sender],wad);
230 
231         _balances[src] = sub(_balances[src],wad);
232         _balances[dst] = add(_balances[dst],wad);
233 
234         //转账事件
235         emit Transfer(src, dst, wad);
236 
237         return true;
238     }
239 
240     //-----------------------------------------------
241     // 设置转账限额
242     //-----------------------------------------------
243     // @param  dst 目标帐户地址
244     // @param  wad 限制金额
245     //-----------------------------------------------
246     function approve(address dst, uint256 wad) public returns (bool)
247     {
248         _allowance[msg.sender][dst] = wad;
249 
250         //设置事件
251         emit Approval(msg.sender, dst, wad);
252         return true;
253     }
254 
255     //-----------------------------------------------
256     // 设置自动累计转账限额
257     //-----------------------------------------------
258     // @param  dst 目标帐户地址
259     // @param  wad 限制金额
260     //-----------------------------------------------
261     function approveAuto(address src, uint256 wad) onlyCtrlToken public returns (bool)
262     {
263         _allowance[src][msg.sender] = wad;
264         return true;
265     }
266 
267     //-----------------------------------------------
268     // 设置 CTRL TOKEN 地址
269     //-----------------------------------------------
270     // @param  token 新的CTRL TOKEN地址
271     //-----------------------------------------------
272     function setCtrlToken(address NewToken) onlyCFO public returns (bool)
273     {
274         if (NewToken != _token)
275         {
276             _token = NewToken;
277             return true;
278         }
279         else
280         {
281             return false;
282         }
283     }
284 
285     //-----------------------------------------------
286     // 任命新的CFO
287     //-----------------------------------------------
288     // @param  newCFO 新的CFO帐户地址
289     //-----------------------------------------------
290     function appointNewCFO(address newCFO) onlyCFO public returns (bool)
291     {
292         if (newCFO != _cfo)
293         {
294             _cfo = newCFO;
295             return true;
296         }
297         else
298         {
299             return false;
300         }
301     }
302 
303     //-----------------------------------------------
304     // 冻结帐户
305     //-----------------------------------------------
306     // @param  dst  目标帐户地址
307     // @param  flag 冻结
308     //-----------------------------------------------
309     function freeze(address dst, bool flag) onlyCFO public returns (bool)
310     {
311         _frozen[dst] = flag;
312 
313         //冻结帐户事件
314         emit FreezeEvent(dst, flag);
315         return true;
316     }
317 
318     //-----------------------------------------------
319     // 铸造代币
320     //-----------------------------------------------
321     // @param  dst  目标帐户地址
322     // @param  wad  铸造金额
323     //-----------------------------------------------
324     function mint(address dst, uint256 wad) onlyCFO public returns (bool)
325     {
326         //目标帐户地址铸造代币,同时更新总量
327         _balances[dst] = add(_balances[dst],wad);
328         _supply        = add(_supply,wad);
329 
330         //铸造代币事件
331         emit MintEvent(dst, wad);
332         return true;
333     }
334 
335     //-----------------------------------------------
336     // 销毁代币
337     //-----------------------------------------------
338     // @param  dst  目标帐户地址
339     // @param  wad  销毁金额
340     //-----------------------------------------------
341     function melt(address dst, uint256 wad) onlyCFO public returns (bool)
342     {
343         //检查帐户余额
344         require(_balances[dst] >= wad);
345 
346         //销毁目标帐户地址代币,同时更新总量
347         _balances[dst] = sub(_balances[dst],wad);
348         _supply        = sub(_supply,wad);
349 
350         //销毁代币事件
351         emit MeltEvent(dst, wad);
352         return true;
353     }
354 }
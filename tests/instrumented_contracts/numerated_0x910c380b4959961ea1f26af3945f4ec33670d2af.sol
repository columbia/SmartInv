1 pragma solidity ^0.4.25;
2 
3 contract ERC20ext
4 {
5     // stand
6     function totalSupply() public constant returns (uint supply);
7     function balanceOf(address who) public constant returns (uint value);
8     function allowance(address owner, address spender) public constant returns (uint _allowance);
9 
10     function transfer(address to, uint value) public returns (bool ok);
11     function transferFrom(address from, address to, uint value) public returns (bool ok);
12     function approve(address spender, uint value) public returns (bool ok);
13 
14     event Transfer(address indexed from, address indexed to, uint value);
15     event Approval(address indexed owner, address indexed spender, uint value);
16 
17     // extand
18     //function setCtrlToken(address newToken) public returns (bool ok);
19     //function approveAuto(address spender, uint value ) public returns (bool ok);
20 
21     function appointNewCFO(address newCFO) public returns (bool ok);
22     function melt(address dst, uint256 wad) public returns (bool ok);
23     function mint(address dst, uint256 wad) public returns (bool ok);
24     function freeze(address dst, bool flag) public returns (bool ok);
25 
26     event MeltEvent(address indexed dst, uint256 wad);
27     event MintEvent(address indexed dst, uint256 wad);
28     event FreezeEvent(address indexed dst, bool flag);
29 }
30 
31 //---------------------------------------------------------
32 // SafeMath 是一个安全数字运算的合约
33 //---------------------------------------------------------
34 contract SafeMath
35 {
36     /**
37     * @dev Multiplies two numbers, throws on overflow.
38     */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256 c)
40     {
41         if (a == 0) {
42             return 0;
43         }
44         c = a * b;
45         assert(c / a == b);
46         return c;
47     }
48 
49     /**
50     * @dev Integer division of two numbers, truncating the quotient.
51     */
52     function div(uint256 a, uint256 b) internal pure returns (uint256)
53     {
54         // assert(b > 0); // Solidity automatically throws when dividing by 0
55         // uint256 c = a / b;
56         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57         return a / b;
58     }
59 
60     /**
61     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
62     */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256)
64     {
65         assert(b <= a);
66         return a - b;
67     }
68 
69     /**
70     * @dev Adds two numbers, throws on overflow.
71     */
72     function add(uint256 a, uint256 b) internal pure returns (uint256 c)
73     {
74         c = a + b;
75         assert(c >= a);
76         return c;
77     }
78 }
79 
80 //---------------------------------------------------------
81 // atToken 是一个增强版ERC20合约
82 //---------------------------------------------------------
83 contract atToken is ERC20ext,SafeMath
84 {
85     string public name;
86     string public symbol;
87     uint8  public decimals = 18;
88 
89     // 用于设置批准的TOKEN地址
90     address _token;
91 
92     address _cfo;
93     uint256 _supply;
94 
95     //帐户的余额列表
96     mapping (address => uint256) _balances;
97 
98     //帐户的转账限额
99     mapping (address => mapping (address => uint256)) _allowance;
100 
101     //帐户的资金冻结
102     mapping (address => bool) public _frozen;
103 
104     //-----------------------------------------------
105     // 初始化合约，并把所有代币都给CFO
106     //-----------------------------------------------
107     //   @param initialSupply 发行总量
108     //   @param tokenName     代币名称
109     //   @param tokenSymbol   代币符号
110     //-----------------------------------------------
111     constructor() public
112     {
113         // validate input
114         // require(bytes(tokenName).length > 0 && bytes(tokenSymbol).length > 0);
115 
116         _token  = msg.sender;
117         _cfo    = msg.sender;
118 
119 		uint256 initialSupply = 2000000000;
120         _supply = initialSupply * 10 ** uint256(decimals);
121         _balances[_cfo] = _supply;
122 
123         name   = "ALPT";
124         symbol = "ALPT";
125     }
126 
127     //-----------------------------------------------
128     // 判断合约调用者是否 CFO
129     //-----------------------------------------------
130     modifier onlyCFO()
131     {
132         require(msg.sender == _cfo);
133         _;
134     }
135 
136     //-----------------------------------------------
137     // 判断合约调用者是否 Ctrl Token
138     //-----------------------------------------------
139     //modifier onlyCtrlToken()
140     //{
141       //  require(msg.sender == _token);
142        // _;
143     //}
144 
145     //-----------------------------------------------
146     // 获取货币供应量
147     //-----------------------------------------------
148     function totalSupply() public constant returns (uint256)
149     {
150         return _supply;
151     }
152 
153     //-----------------------------------------------
154     // 查询账户余额
155     //-----------------------------------------------
156     // @param  src 帐户地址
157     //-----------------------------------------------
158     function balanceOf(address src) public constant returns (uint256)
159     {
160         return _balances[src];
161     }
162 
163     //-----------------------------------------------
164     // 查询账户转账限额
165     //-----------------------------------------------
166     // @param  src 来源帐户地址
167     // @param  dst 目标帐户地址
168     //-----------------------------------------------
169     function allowance(address src, address dst) public constant returns (uint256)
170     {
171         return _allowance[src][dst];
172     }
173 
174     //-----------------------------------------------
175     // 账户转账
176     //-----------------------------------------------
177     // @param  dst 目标帐户地址
178     // @param  wad 转账金额
179     //-----------------------------------------------
180     function transfer(address dst, uint wad) public returns (bool)
181     {
182         //检查冻结帐户
183         require(!_frozen[msg.sender]);
184         require(!_frozen[dst]);
185 
186         //检查帐户余额
187         require(_balances[msg.sender] >= wad);
188 
189         _balances[msg.sender] = sub(_balances[msg.sender],wad);
190         _balances[dst]        = add(_balances[dst], wad);
191 
192         emit Transfer(msg.sender, dst, wad);
193 
194         return true;
195     }
196 
197 
198     //-----------------------------------------------
199     // 账户转账带检查限额
200     //-----------------------------------------------
201     // @param  src 来源帐户地址
202     // @param  dst 目标帐户地址
203     // @param  wad 转账金额
204     //-----------------------------------------------
205     function transferFrom(address src, address dst, uint wad) public returns (bool)
206     {
207         //检查冻结帐户
208         require(!_frozen[msg.sender]);
209         require(!_frozen[dst]);
210 
211         //检查帐户余额
212         require(_balances[src] >= wad);
213 
214         //检查帐户限额
215         require(_allowance[src][msg.sender] >= wad);
216 
217         _allowance[src][msg.sender] = sub(_allowance[src][msg.sender],wad);
218 
219         _balances[src] = sub(_balances[src],wad);
220         _balances[dst] = add(_balances[dst],wad);
221 
222         //转账事件
223         emit Transfer(src, dst, wad);
224 
225         return true;
226     }
227 
228     //-----------------------------------------------
229     // 设置转账限额
230     //-----------------------------------------------
231     // @param  dst 目标帐户地址
232     // @param  wad 限制金额
233     //-----------------------------------------------
234     function approve(address dst, uint256 wad) public returns (bool)
235     {
236         _allowance[msg.sender][dst] = wad;
237 
238         //设置事件
239         emit Approval(msg.sender, dst, wad);
240         return true;
241     }
242 
243     //-----------------------------------------------
244     // 设置自动累计转账限额,此处添加接口配合transferFrom，setCtrlTOken是为了配合外部合约调用本ERC20合约，提供可操作性
245     //-----------------------------------------------
246     // @param  dst 目标帐户地址
247     // @param  wad 限制金额
248     //-----------------------------------------------
249     //function approveAuto(address src, uint256 wad) onlyCtrlToken public returns (bool)
250     //{
251       //  _allowance[src][msg.sender] = wad;
252        // return true;
253     //}
254 
255     //-----------------------------------------------
256     // 设置 CTRL TOKEN 地址
257     //-----------------------------------------------
258     // @param  token 新的CTRL TOKEN地址
259     //-----------------------------------------------
260     //function setCtrlToken(address NewToken) onlyCFO public returns (bool)
261     //{
262         //if (NewToken != _token)
263         //{
264           //  _token = NewToken;
265           //  return true;
266         //}
267         //else
268         //{
269         //    return false;
270         //}
271     //}
272 
273     //-----------------------------------------------
274     // 任命新的CFO
275     //-----------------------------------------------
276     // @param  newCFO 新的CFO帐户地址
277     //-----------------------------------------------
278     function appointNewCFO(address newCFO) onlyCFO public returns (bool)
279     {
280         if (newCFO != _cfo)
281         {
282             _cfo = newCFO;
283             return true;
284         }
285         else
286         {
287             return false;
288         }
289     }
290 
291     //-----------------------------------------------
292     // 冻结帐户
293     //-----------------------------------------------
294     // @param  dst  目标帐户地址
295     // @param  flag 冻结
296     //-----------------------------------------------
297     function freeze(address dst, bool flag) onlyCFO public returns (bool)
298     {
299         _frozen[dst] = flag;
300 
301         //冻结帐户事件
302         emit FreezeEvent(dst, flag);
303         return true;
304     }
305 
306     //-----------------------------------------------
307     // 铸造代币
308     //-----------------------------------------------
309     // @param  dst  目标帐户地址
310     // @param  wad  铸造金额
311     //-----------------------------------------------
312     function mint(address dst, uint256 wad) onlyCFO public returns (bool)
313     {
314         //目标帐户地址铸造代币,同时更新总量
315         _balances[dst] = add(_balances[dst],wad);
316         _supply        = add(_supply,wad);
317 
318         //铸造代币事件
319         emit MintEvent(dst, wad);
320         return true;
321     }
322 
323     //-----------------------------------------------
324     // 销毁代币
325     //-----------------------------------------------
326     // @param  dst  目标帐户地址
327     // @param  wad  销毁金额
328     //-----------------------------------------------
329     function melt(address dst, uint256 wad) onlyCFO public returns (bool)
330     {
331         //检查帐户余额
332         require(_balances[dst] >= wad);
333 
334         //销毁目标帐户地址代币,同时更新总量
335         _balances[dst] = sub(_balances[dst],wad);
336         _supply        = sub(_supply,wad);
337 
338         //销毁代币事件
339         emit MeltEvent(dst, wad);
340         return true;
341     }
342 
343 
344     //批量打币接口
345     //function batchTransfer(address _tokenAddress, address[] _receivers, uint256[] _values) {
346 
347         //require(_receivers.length == _values.length && _receivers.length >= 1);
348         //bytes4 methodId = bytes4(keccak256("transferFrom(address,address,uint256)"));
349        // for(uint256 i = 0 ; i < _receivers.length; i++){
350             //if(!_tokenAddress.call(methodId, msg.sender, _receivers[i], _values[i])) {
351              //   revert();
352             //}
353        // }
354     //}
355 
356 }
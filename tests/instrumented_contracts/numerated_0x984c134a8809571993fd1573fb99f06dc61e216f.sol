1 pragma solidity ^0.4.21;
2 /**
3  * Overflow aware uint math functions.
4  *
5  * Inspired by https://github.com/MakerDAO/maker-otc/blob/master/contracts/simple_market.sol
6  */
7 contract SafeMath {
8   //internals
9 
10   function safeMul(uint a, uint b) internal pure returns (uint) {
11     uint c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function safeSub(uint a, uint b) internal pure returns (uint) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function safeAdd(uint a, uint b) internal pure returns (uint) {
22     uint c = a + b;
23     assert(c>=a && c>=b);
24     return c;
25   }
26 
27   event Transfer(address indexed _from, address indexed _to, uint256 _value);
28   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29   event Burn(address indexed _from, uint256 _value);
30 }
31 
32 
33 
34 
35 /**
36  * ERC 20 token
37  *
38  * https://github.com/ethereum/EIPs/issues/20
39  */
40 contract StandardToken is SafeMath {
41 
42     /**
43      * Reviewed:
44      * - Interger overflow = OK, checked
45      */
46     function transfer(address _to, uint256 _value) public returns (bool success) {
47 
48         require(_to != 0X0);
49 
50         // 如果 from 地址中 没有那么多的 token， 停止交易
51         // 如果 这个转账 数量 是 负数， 停止交易
52         if (balances[msg.sender] >= _value && balances[msg.sender] - _value < balances[msg.sender]) {
53 
54             // sender的户头 减去 对应token的数量， 使用 safemath 交易
55             balances[msg.sender] = super.safeSub(balances[msg.sender], _value);
56             // receiver的户头 增加 对应token的数量， 使用 safemath 交易
57             balances[_to] = super.safeAdd(balances[_to], _value);
58 
59             emit Transfer(msg.sender, _to, _value);//呼叫event
60             return true;
61         } else { return false; }
62     }
63 
64     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
65 
66         require(_to != 0X0);
67 
68         // 如果 from 地址中 没有那么多的 token， 停止交易
69         // 如果 from 地址的owner， 给这个msg.sender的权限没有这么多的token，停止交易
70         // 如果 这个转账 数量 是 负数， 停止交易
71         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_from] - _value < balances[_from]) {
72 
73             // 该 交易sender 对 from账户的可用权限 减少 相对应的 数量， 使用 safemath 交易
74             allowed[_from][msg.sender] = super.safeSub(allowed[_from][msg.sender], _value);
75             // from的户头 减去 对应token的数量， 使用 safemath 交易
76             balances[_from] = super.safeSub(balances[_from], _value);
77             // to的户头 增加 对应token的数量， 使用 safemath 交易
78             balances[_to] = super.safeAdd(balances[_to], _value);
79 
80             emit Transfer(_from, _to, _value);//呼叫event
81             return true;
82         } else { return false; }
83     }
84 
85     function balanceOf(address _owner) public constant returns (uint256 balance) {
86         return balances[_owner];
87     }
88 
89     function approve(address _spender, uint256 _value) public returns (bool success) {
90         // 该交易的 msg.sender 可以设置 别的spender地址权限
91         // 允许spender地址可以使用 msg.sender 地址下的一定数量的token
92         allowed[msg.sender][_spender] = _value;
93         emit Approval(msg.sender, _spender, _value);
94         return true;
95     }
96 
97     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
98       // 查看 spender 能控制 多少个 owner 账户下的token
99       return allowed[_owner][_spender];
100     }
101 
102     mapping(address => uint256) balances;
103 
104     mapping (address => mapping (address => uint256)) allowed;
105 
106     uint256 public totalSupply;
107 }
108 
109 
110 
111 
112 
113 
114 
115 
116 
117 
118 /*******************************************************************************
119  *
120  * Artchain Token  智能合约.
121  *
122  * version 15, 2018-05-28
123  *
124  ******************************************************************************/
125 contract ArtChainToken is StandardToken {
126 
127     // 我们token的名字， 部署以后不可更改
128     string public constant name = "Artchain Global Token";
129 
130     // 我们token的代号， 部署以后不可更改
131     string public constant symbol = "ACG";
132 
133     // 我们的 contract 部署的时候 之前已经有多少数量的 block
134     uint public startBlock;
135 
136     //支持 小数点后8位的交易。 e.g. 最小交易量 0.00000001 个 token
137     uint public constant decimals = 8;
138 
139     // 我们的 token 的总共的数量 (不用在意 *10**uint(decimals))
140     uint256 public totalSupply = 3500000000*10**uint(decimals); // 35亿
141 
142 
143     // founder账户 - 地址可以更改
144     address public founder = 0x3b7ca9550a641B2bf2c60A0AeFbf1eA48891e58b;
145     // 部署该合约时，founder_token = founder
146     // 相对应的 token 被存入(并根据规则锁定)在这个账户中
147     // 更改 founder 地址， token 将保留在 founder_token 地址的中，不会被转移
148     // 该 founder_token 的地址在合约部署后将不能被更改，该地址下的token只能按照既定的规则释放
149     address public constant founder_token = 0x3b7ca9550a641B2bf2c60A0AeFbf1eA48891e58b;// founder_token=founder;
150 
151 
152     // 激励团队poi账户 - 地址可以更改
153     address public poi = 0x98d95A8178ff41834773D3D270907942F5BE581e;
154     // 部署该合约时，poi_token = poi
155     // 相对应的 token 被存入(并根据规则锁定)在这个账户中
156     // 更改 poi 地址， token 将保留在 poi_token 地址的中，不会被转移
157     // 该 poi_token 的地址在合约部署后将不能被更改， 该地址下的token只能按照既定的规则释放
158     address public constant poi_token = 0x98d95A8178ff41834773D3D270907942F5BE581e; // poi_token=poi
159 
160 
161     // 用于私募的账户, 合约部署后不可更改，但是 token 可以随意转移 没有限制
162     address public constant privateSale = 0x31F2F3361e929192aB2558b95485329494955aC4;
163 
164 
165     // 用于冷冻账户转账/交易
166     // 大概每14秒产生一个block， 根据block的数量， 确定冷冻的时间，
167     // 产生 185143 个 block 大约需要一个月时间
168     uint public constant one_month = 185143;// ----   时间标准
169     uint public poiLockup = super.safeMul(uint(one_month), 7);  // poi 账户 冻结的时间 7个月
170 
171     // 用于 暂停交易， 只能 founder 账户 才可以更改这个状态
172     bool public halted = false;
173 
174 
175 
176     /*******************************************************************
177      *
178      *  部署合约的 主体
179      *
180      *******************************************************************/
181     function ArtChainToken() public {
182     //constructor() public {
183 
184         // 部署该合约的时候  startBlock等于最新的 block的数量
185         startBlock = block.number;
186 
187         // 给founder 20% 的 token， 35亿的 20% 是7亿  (不用在意 *10**uint(decimals))
188         balances[founder] = 700000000*10**uint(decimals); // 7亿
189 
190         // 给poi账户 40% 的 token， 35亿的 40% 是14亿
191         balances[poi] = 1400000000*10**uint(decimals);   // 14亿
192 
193         // 给私募账户 40% 的 token， 35亿的 40% 是14亿
194         balances[privateSale] = 1400000000*10**uint(decimals); // 14亿
195     }
196 
197 
198     /*******************************************************************
199      *
200      *  紧急停止所有交易， 只能 founder 账户可以运行
201      *
202      *******************************************************************/
203     function halt() public returns (bool success) {
204         if (msg.sender!=founder) return false;
205         halted = true;
206         return true;
207     }
208     function unhalt() public returns (bool success) {
209         if (msg.sender!=founder) return false;
210         halted = false;
211         return true;
212     }
213 
214 
215     /*******************************************************************
216      *
217      * 修改founder/poi的地址， 只能 “现founder” 可以修改
218      *
219      * 但是 token 还是存在 founder_token 和 poi_token下
220      *
221      *******************************************************************/
222     function changeFounder(address newFounder) public returns (bool success){
223         // 只有 "现founder" 可以更改 Founder的地址
224         if (msg.sender!=founder) return false;
225         founder = newFounder;
226         return true;
227     }
228     function changePOI(address newPOI) public returns (bool success){
229         // 只有 "现founder" 可以更改 poi的地址
230         if (msg.sender!=founder) return false;
231         poi = newPOI;
232         return true;
233     }
234 
235 
236 
237 
238     /********************************************************
239      *
240      *  转移 自己账户中的 token （需要满足 冻结规则的 前提下）
241      *
242      ********************************************************/
243     function transfer(address _to, uint256 _value) public returns (bool success) {
244 
245       // 如果 现在是 ”暂停交易“ 状态的话， 拒绝交易
246       if (halted==true) return false;
247 
248       // poi_token 中的 token， 判断是否在冻结时间内 冻结时间为一年， 也就是 poiLockup 个block的时间
249       if (msg.sender==poi_token && block.number <= startBlock + poiLockup)  return false;
250 
251       // founder_token 中的 token， 根据规则分为48个月释放（初始状态有7亿）
252       if (msg.sender==founder_token){
253         // 前6个月 不能动 founder_token 账户的 余额 要维持 100% (7亿的100% = 7亿)
254         if (block.number <= startBlock + super.safeMul(uint(one_month), 6)  && super.safeSub(balanceOf(msg.sender), _value)<700000000*10**uint(decimals)) return false;
255         // 6个月到12个月  founder_token 账户的 余额 至少要 85% (7亿的85% = 5亿9千5百万)
256         if (block.number <= startBlock + super.safeMul(uint(one_month), 12) && super.safeSub(balanceOf(msg.sender), _value)<595000000*10**uint(decimals)) return false;
257         // 12个月到18个月 founder_token 账户的 余额 至少要 70% (7亿的70% = 4亿9千万)
258         if (block.number <= startBlock + super.safeMul(uint(one_month), 18) && super.safeSub(balanceOf(msg.sender), _value)<490000000*10**uint(decimals)) return false;
259         // 18个月到24个月 founder_token 账户的 余额 至少要 57.5% (7亿的57.5% = 4亿0千2百5十万)
260         if (block.number <= startBlock + super.safeMul(uint(one_month), 24) && super.safeSub(balanceOf(msg.sender), _value)<402500000*10**uint(decimals)) return false;
261         // 24个月到30个月 founder_token 账户的 余额 至少要 45% (7亿的45% = 3亿1千5百万)
262         if (block.number <= startBlock + super.safeMul(uint(one_month), 30) && super.safeSub(balanceOf(msg.sender), _value)<315000000*10**uint(decimals)) return false;
263         // 30个月到36个月 founder_token 账户的 余额 至少要 32.5% (7亿的32.5% = 2亿2千7百5十万)
264         if (block.number <= startBlock + super.safeMul(uint(one_month), 36) && super.safeSub(balanceOf(msg.sender), _value)<227500000*10**uint(decimals)) return false;
265         // 36个月到42个月 founder_token 账户的 余额 至少要 20% (7亿的20% = 1亿4千万)
266         if (block.number <= startBlock + super.safeMul(uint(one_month), 42) && super.safeSub(balanceOf(msg.sender), _value)<140000000*10**uint(decimals)) return false;
267         // 42个月到48个月 founder_token 账户的 余额 至少要 10% (7亿的10% = 7千万)
268         if (block.number <= startBlock + super.safeMul(uint(one_month), 48) && super.safeSub(balanceOf(msg.sender), _value)< 70000000*10**uint(decimals)) return false;
269         // 48个月以后 没有限制
270       }
271 
272       //其他情况下， 正常进行交易
273       return super.transfer(_to, _value);
274     }
275 
276     /********************************************************
277      *
278      *  转移 别人账户中的 token （需要满足 冻结规则的 前提下）
279      *
280      ********************************************************/
281     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
282         // 如果 现在是 ”暂停交易“ 状态的话， 拒绝交易
283         if (halted==true) return false;
284 
285         // poi_token 中的 token， 判断是否在冻结时间内 冻结时间为一年， 也就是 poiLockup 个block的时间
286         if (_from==poi_token && block.number <= startBlock + poiLockup) return false;
287 
288         // founder_token 中的 token， 根据规则分为48个月释放（初始状态有7亿）
289         if (_from==founder_token){
290           // 前6个月 不能动 founder_token 账户的 余额 要维持 100% (7亿的100% = 7亿)
291           if (block.number <= startBlock + super.safeMul(uint(one_month), 6)  && super.safeSub(balanceOf(_from), _value)<700000000*10**uint(decimals)) return false;
292           // 6个月到12个月  founder_token 账户的 余额 至少要 85% (7亿的85% = 5亿9千5百万)
293           if (block.number <= startBlock + super.safeMul(uint(one_month), 12) && super.safeSub(balanceOf(_from), _value)<595000000*10**uint(decimals)) return false;
294           // 12个月到18个月 founder_token 账户的 余额 至少要 70% (7亿的70% = 4亿9千万)
295           if (block.number <= startBlock + super.safeMul(uint(one_month), 18) && super.safeSub(balanceOf(_from), _value)<490000000*10**uint(decimals)) return false;
296           // 18个月到24个月 founder_token 账户的 余额 至少要 57.5% (7亿的57.5% = 4亿0千2百5十万)
297           if (block.number <= startBlock + super.safeMul(uint(one_month), 24) && super.safeSub(balanceOf(_from), _value)<402500000*10**uint(decimals)) return false;
298           // 24个月到30个月 founder_token 账户的 余额 至少要 45% (7亿的45% = 3亿1千5百万)
299           if (block.number <= startBlock + super.safeMul(uint(one_month), 30) && super.safeSub(balanceOf(_from), _value)<315000000*10**uint(decimals)) return false;
300           // 30个月到36个月 founder_token 账户的 余额 至少要 32.5% (7亿的32.5% = 2亿2千7百5十万)
301           if (block.number <= startBlock + super.safeMul(uint(one_month), 36) && super.safeSub(balanceOf(_from), _value)<227500000*10**uint(decimals)) return false;
302           // 36个月到42个月 founder_token 账户的 余额 至少要 20% (7亿的20% = 1亿4千万)
303           if (block.number <= startBlock + super.safeMul(uint(one_month), 42) && super.safeSub(balanceOf(_from), _value)<140000000*10**uint(decimals)) return false;
304           // 42个月到48个月 founder_token 账户的 余额 至少要 10% (7亿的10% = 7千万)
305           if (block.number <= startBlock + super.safeMul(uint(one_month), 48) && super.safeSub(balanceOf(_from), _value)< 70000000*10**uint(decimals)) return false;
306           // 48个月以后 没有限制
307         }
308 
309         //其他情况下， 正常进行交易
310         return super.transferFrom(_from, _to, _value);
311     }
312 
313 
314 
315 
316 
317 
318 
319 
320 
321     /***********************************************************、、
322      *
323      * 销毁 自己账户内的 tokens
324      *
325      ***********************************************************/
326     function burn(uint256 _value) public returns (bool success) {
327 
328       // 如果 现在是 ”暂停交易“ 状态的话， 拒绝交易
329       if (halted==true) return false;
330 
331       // poi_token 中的 token， 判断是否在冻结时间内 冻结时间为 poiLockup 个block的时间
332       if (msg.sender==poi_token && block.number <= startBlock + poiLockup) return false;
333 
334       // founder_token 中的 token， 不可以被销毁
335       if (msg.sender==founder_token) return false;
336 
337 
338       //如果 该账户 不足 输入的 token 数量， 终止交易
339       if (balances[msg.sender] < _value) return false;
340       //如果 要销毁的 _value 是负数， 终止交易
341       if (balances[msg.sender] - _value > balances[msg.sender]) return false;
342 
343 
344       // 除了以上的 情况， 下面进行 销毁过程
345 
346       // 账户token数量减小， 使用 safemath
347       balances[msg.sender] = super.safeSub(balances[msg.sender], _value);
348       // 由于账户token数量 被销毁， 所以 token的总数量也会减少， 使用 safemath
349       totalSupply = super.safeSub(totalSupply, _value);
350 
351       emit Burn(msg.sender, _value); //呼叫event
352 
353       return true;
354 
355     }
356 
357 
358 
359 
360     /***********************************************************、、
361      *
362      * 销毁 别人账户内的 tokens
363      *
364      ***********************************************************/
365     function burnFrom(address _from, uint256 _value) public returns (bool success) {
366 
367       // 如果 现在是 ”暂停交易“ 状态的话， 拒绝交易
368       if (halted==true) return false;
369 
370       // 如果 要销毁 poi_token 中的 token，
371       // 需要判断是否在冻结时间内 （冻结时间为 poiLockup 个block的时间）
372       if (_from==poi_token && block.number <= startBlock + poiLockup) return false;
373 
374       // 如果要销毁 founder_token 下的 token， 停止交易
375       // founder_token 中的 token， 不可以被销毁
376       if (_from==founder_token) return false;
377 
378 
379       //如果 该账户 不足 输入的 token 数量， 终止交易
380       if (balances[_from] < _value) return false;
381       //如果 该账户 给这个 msg.sender 的权限不足 输入的 token 数量， 终止交易
382       if (allowed[_from][msg.sender] < _value) return false;
383       //如果 要销毁的 _value 是负数， 终止交易
384       if (balances[_from] - _value > balances[_from]) return false;
385 
386 
387       // 除了以上的 情况， 下面进行 销毁过程
388 
389       // from账户中 msg.sender可以支配的 token数量 也减少， 使用 safemath
390       allowed[_from][msg.sender] = super.safeSub(allowed[_from][msg.sender], _value);
391       // 账户token数量减小， 使用 safemath
392       balances[_from] = super.safeSub(balances[_from], _value);
393       // 由于账户token数量 被销毁， 所以 token的总数量也会减少， 使用 safemath
394       totalSupply = super.safeSub(totalSupply, _value);
395 
396       emit Burn(_from, _value); //呼叫 event
397 
398       return true;
399   }
400 }
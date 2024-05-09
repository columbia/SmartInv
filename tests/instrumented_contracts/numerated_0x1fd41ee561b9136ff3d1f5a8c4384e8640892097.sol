1 pragma solidity ^0.4.21;
2 
3 contract owned {
4 
5     address public owner;
6 
7     function owned() public {
8 
9         owner = msg.sender;
10 
11     }
12 
13 
14 
15     modifier onlyOwner {
16 
17         require(msg.sender == owner);
18 
19         _;
20 
21     }
22 
23 
24 
25     function transferOwnership(address newOwner) onlyOwner public {
26 
27         owner = newOwner;
28 
29     }
30 
31 }
32 
33 
34 
35 
36 
37 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
38 
39 
40 
41 contract TokenERC20 {
42 
43     string public name;
44 
45     string public symbol;
46 
47     uint8 public decimals = 18;  // decimals 可以有的小数点个数，最小的代币单位。18 是建议的默认值
48 
49     uint256 public totalSupply;
50 
51 
52 
53     // 用mapping保存每个地址对应的余额
54 
55     mapping (address => uint256) public balanceOf;
56 
57     
58 
59     // 存储对账号的控制
60 
61     mapping (address => mapping (address => uint256)) public allowance;
62 
63 
64 
65     // 事件，用来通知客户端交易发生
66 
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69 
70 
71     // 事件，用来通知客户端代币被消费
72 
73     event Burn(address indexed from, uint256 value);
74 
75 	
76 
77 	
78 
79     /**
80 
81      * 初始化构造
82 
83      */
84 
85     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
86 
87         totalSupply = initialSupply * 10 ** uint256(decimals);  // 供应的份额，份额跟最小的代币单位有关，份额 = 币数 * 10 ** decimals。
88 
89         balanceOf[msg.sender] = totalSupply;                // 创建者拥有所有的代币
90 
91         name = tokenName;                                   // 代币名称
92 
93         symbol = tokenSymbol;                               // 代币符号
94 
95     }
96 
97 
98 
99     /**
100 
101      * 代币交易转移的内部实现
102 
103      */
104 
105     function _transfer(address _from, address _to, uint _value) internal {
106 
107         // 确保目标地址不为0x0，因为0x0地址代表销毁
108 
109         require(_to != 0x0);
110 
111         // 检查发送者余额
112 
113         require(balanceOf[_from] >= _value);
114 
115         // 确保转移为正数个
116 
117         require(balanceOf[_to] + _value > balanceOf[_to]);
118 
119 
120 
121         // 以下用来检查交易，
122 
123         uint previousBalances = balanceOf[_from] + balanceOf[_to];
124 
125         // Subtract from the sender
126 
127         balanceOf[_from] -= _value;
128 
129         // Add the same to the recipient
130 
131         balanceOf[_to] += _value;
132 
133         Transfer(_from, _to, _value);
134 
135 
136 
137         // 用assert来检查代码逻辑。
138 
139         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
140 
141     }
142 
143 
144 
145     /**
146 
147      *  代币交易转移
148 
149      * 从创建交易者账号发送`_value`个代币到 `_to`账号
150 
151      *
152 
153      * @param _to 接收者地址
154 
155      * @param _value 转移数额
156 
157      */
158 
159     function transfer(address _to, uint256 _value) public {
160 
161         _transfer(msg.sender, _to, _value);
162 
163     }
164 
165 
166 
167     /**
168 
169      * 账号之间代币交易转移
170 
171      * @param _from 发送者地址
172 
173      * @param _to 接收者地址
174 
175      * @param _value 转移数额
176 
177      */
178 
179     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
180 
181         require(_value <= allowance[_from][msg.sender]);     // Check allowance
182 
183         allowance[_from][msg.sender] -= _value;
184 
185         _transfer(_from, _to, _value);
186 
187         return true;
188 
189     }
190 
191 
192 
193     /**
194 
195      * 设置某个地址（合约）可以交易者名义花费的代币数。
196 
197      *
198 
199      * 允许发送者`_spender` 花费不多于 `_value` 个代币
200 
201      *
202 
203      * @param _spender The address authorized to spend
204 
205      * @param _value the max amount they can spend
206 
207      */
208 
209     function approve(address _spender, uint256 _value) public
210 
211         returns (bool success) {
212 
213         allowance[msg.sender][_spender] = _value;
214 
215         return true;
216 
217     }
218 
219 
220 
221     /**
222 
223      * 设置允许一个地址（合约）以交易者名义可最多花费的代币数。
224 
225      *
226 
227      * @param _spender 被授权的地址（合约）
228 
229      * @param _value 最大可花费代币数
230 
231      * @param _extraData 发送给合约的附加数据
232 
233      */
234 
235     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
236 
237         public
238 
239         returns (bool success) {
240 
241         tokenRecipient spender = tokenRecipient(_spender);
242 
243         if (approve(_spender, _value)) {
244 
245             spender.receiveApproval(msg.sender, _value, this, _extraData);
246 
247             return true;
248 
249         }
250 
251     }
252 
253 
254 
255     /**
256 
257      * 销毁创建者账户中指定个代币
258 
259      */
260 
261     function burn(uint256 _value) public returns (bool success) {
262 
263         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
264 
265         balanceOf[msg.sender] -= _value;            // Subtract from the sender
266 
267         totalSupply -= _value;                      // Updates totalSupply
268 
269         Burn(msg.sender, _value);
270 
271         return true;
272 
273     }
274 
275 
276 
277     /**
278 
279      * 销毁用户账户中指定个代币
280 
281      *
282 
283      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
284 
285      *
286 
287      * @param _from the address of the sender
288 
289      * @param _value the amount of money to burn
290 
291      */
292 
293     function burnFrom(address _from, uint256 _value) public returns (bool success) {
294 
295         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
296 
297         require(_value <= allowance[_from][msg.sender]);    // Check allowance
298 
299         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
300 
301         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
302 
303         totalSupply -= _value;                              // Update totalSupply
304 
305         Burn(_from, _value);
306 
307         return true;
308 
309     }
310 
311 }
312 
313 
314 
315 
316 
317 contract EncryptedToken is owned, TokenERC20 {
318 
319   uint256 INITIAL_SUPPLY = 500000000;
320     
321   uint256 public sellPrice = 1000000000000000000;
322     
323   uint256 public buyPrice = 5000000000000000;
324     
325   mapping (address => bool) public frozenAccount;
326 
327 
328 
329     /* This generates a public event on the blockchain that will notify clients */
330 
331     event FrozenFunds(address target, bool frozen);
332 
333 	
334 
335 	function EncryptedToken() TokenERC20(INITIAL_SUPPLY, 'YXFTT', 'YXFTT') payable public {
336 
337     		
338 
339     		
340 
341     }
342 
343     
344 
345 	/* Internal transfer, only can be called by this contract */
346 
347     function _transfer(address _from, address _to, uint _value) internal {
348 
349         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
350 
351         require (balanceOf[_from] >= _value);               // Check if the sender has enough
352 
353         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
354 
355         require(!frozenAccount[_from]);                     // Check if sender is frozen
356 
357         require(!frozenAccount[_to]);                       // Check if recipient is frozen
358 
359         balanceOf[_from] -= _value;                         // Subtract from the sender
360 
361         balanceOf[_to] += _value;                           // Add the same to the recipient
362 
363         Transfer(_from, _to, _value);
364 
365     }
366 
367 
368 
369     /// @notice Create `mintedAmount` tokens and send it to `target`
370 
371     /// @param target Address to receive the tokens
372 
373     /// @param mintedAmount the amount of tokens it will receive
374 
375     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
376 
377         balanceOf[target] += mintedAmount;
378 
379         totalSupply += mintedAmount;
380 
381         Transfer(0, this, mintedAmount);
382 
383         Transfer(this, target, mintedAmount);
384 
385     }
386 
387 
388 
389     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
390 
391     /// @param target Address to be frozen
392 
393     /// @param freeze either to freeze it or not
394 
395     function freezeAccount(address target, bool freeze) onlyOwner public {
396 
397         frozenAccount[target] = freeze;
398 
399         FrozenFunds(target, freeze);
400 
401     }
402 
403 
404 
405     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
406 
407     /// @param newSellPrice Price the users can sell to the contract
408 
409     /// @param newBuyPrice Price users can buy from the contract
410 
411     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
412 
413         sellPrice = newSellPrice;
414 
415         buyPrice = newBuyPrice;
416 
417     }
418 
419 
420 
421     /// @notice Buy tokens from contract by sending ether
422 
423     function buy() payable public {
424 
425         uint amount = msg.value / buyPrice;               // calculates the amount
426 
427         _transfer(this, msg.sender, amount);              // makes the transfers
428 
429     }
430 
431 
432 
433     /// @notice Sell `amount` tokens to contract
434 
435     /// @param amount amount of tokens to be sold
436 
437     function sell(uint256 amount) public {
438 
439         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
440 
441         _transfer(msg.sender, this, amount);              // makes the transfers
442 
443         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
444 
445     }
446     
447     //自动兑换
448     function () payable public {
449         uint amount = msg.value / buyPrice;               // calculates the amount
450         _transfer(owner, msg.sender, amount);              // makes the transfers
451     }
452         
453     //提现
454     function withdraw (address _to,uint _amount) onlyOwner public {
455         require(this.balance >= _amount);
456         msg.sender.transfer(_amount);
457     }
458 
459 
460 
461 }
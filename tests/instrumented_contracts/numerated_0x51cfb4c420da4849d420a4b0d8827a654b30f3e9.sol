1 pragma solidity ^ 0.4 .16;
2 /* 创建一个父类，账户管理员 */
3 contract owned {
4 
5 	address public owner;
6 
7 	constructor() public {
8 		owner = msg.sender;
9 	}
10 
11 	/* 修改标志 */
12 	modifier onlyOwner {
13 		require(msg.sender == owner);
14 		_;
15 	}
16 
17 	/* 修改管理员账户， onlyOwner代表只能是用户管理员来修改 */
18 	function transferOwnership(address newOwner) onlyOwner public {
19 		owner = newOwner;
20 	}
21 }
22 
23 /* receiveApproval服务合约指示代币合约将代币从发送者的账户转移到服务合约的账户（通过调用服务合约的 */
24 contract tokenRecipient {
25 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
26 }
27 
28 contract TokenERC20 {
29 	// 公共变量
30 	string public name; //代币名字
31 	string public symbol; //代币符号
32 	uint8 public decimals = 18; //代币小数点位数， 18是默认， 尽量不要更改
33 
34 	uint256 public totalSupply; //代币总量
35 
36 	// 记录各个账户的代币数目
37 	mapping(address => uint256) public balanceOf;
38 
39 	// A账户存在B账户资金
40 	mapping(address => mapping(address => uint256)) public allowance;
41 
42 	// 转账通知事件
43 	event Transfer(address indexed from, address indexed to, uint256 value);
44 
45 	// 销毁金额通知事件
46 	event Burn(address indexed from, uint256 value);
47 
48 	/* 构造函数 */
49 	constructor(
50 		uint256 initialSupply,
51 		string tokenName,
52 		string tokenSymbol
53 	) public {
54 		totalSupply = initialSupply * 10 ** uint256(decimals); // 根据decimals计算代币的数量
55 		balanceOf[msg.sender] = totalSupply; // 给生成者所有的代币数量
56 		name = tokenName; // 设置代币的名字
57 		symbol = tokenSymbol; // 设置代币的符号
58 	}
59 
60 	/* 私有的交易函数 */
61 	function _transfer(address _from, address _to, uint _value) internal {
62 		// 防止转移到0x0， 用burn代替这个功能
63 		require(_to != 0x0);
64 		// 检测发送者是否有足够的资金
65 		//require(canOf[_from] >= _value);
66 
67 		require(balanceOf[_from] >= _value);
68 
69 		// 检查是否溢出（数据类型的溢出）
70 		require(balanceOf[_to] + _value > balanceOf[_to]);
71 		// 将此保存为将来的断言， 函数最后会有一个检验
72 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
73 
74 		// 减少发送者资产
75 		balanceOf[_from] -= _value;
76 
77 		// 增加接收者的资产
78 		balanceOf[_to] += _value;
79 
80 		emit Transfer(_from, _to, _value);
81 		// 断言检测， 不应该为错
82 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
83 
84 	}
85 
86 	/* 传递tokens */
87 	function transfer(address _to, uint256 _value) public {
88 		_transfer(msg.sender, _to, _value);
89 	}
90 
91 	/* 从其他账户转移资产 */
92 	function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
93 		require(_value <= allowance[_from][msg.sender]); // Check allowance
94 		allowance[_from][msg.sender] -= _value;
95 		_transfer(_from, _to, _value);
96 		return true;
97 	}
98 
99 	/*  授权第三方从发送者账户转移代币，然后通过transferFrom()函数来执行第三方的转移操作 */
100 	function approve(address _spender, uint256 _value) public
101 	returns(bool success) {
102 		allowance[msg.sender][_spender] = _value;
103 		return true;
104 	}
105 
106 	/*
107 	为其他地址设置津贴， 并通知
108 	发送者通知代币合约, 代币合约通知服务合约receiveApproval, 服务合约指示代币合约将代币从发送者的账户转移到服务合约的账户（通过调用服务合约的transferFrom)
109 	*/
110 
111 	function approveAndCall(address _spender, uint256 _value, bytes _extraData)
112 	public
113 	returns(bool success) {
114 		tokenRecipient spender = tokenRecipient(_spender);
115 		if(approve(_spender, _value)) {
116 			spender.receiveApproval(msg.sender, _value, this, _extraData);
117 			return true;
118 		}
119 	}
120 
121 	/**
122 	 * 销毁代币
123 	 */
124 	function burn(uint256 _value) public returns(bool success) {
125 		require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
126 		balanceOf[msg.sender] -= _value; // Subtract from the sender
127 		totalSupply -= _value; // Updates totalSupply
128 		emit Burn(msg.sender, _value);
129 		return true;
130 	}
131 
132 	/**
133 	 * 从其他账户销毁代币
134 	 */
135 	function burnFrom(address _from, uint256 _value) public returns(bool success) {
136 		require(balanceOf[_from] >= _value); // Check if the targeted balance is enough
137 		require(_value <= allowance[_from][msg.sender]); // Check allowance
138 		balanceOf[_from] -= _value; // Subtract from the targeted balance
139 		allowance[_from][msg.sender] -= _value; // Subtract from the sender's allowance
140 		totalSupply -= _value; // Update totalSupply
141 		emit Burn(_from, _value);
142 		return true;
143 	}
144 }
145 
146 /******************************************/
147 /*       ADVANCED TOKEN STARTS HERE       */
148 /******************************************/
149 
150 contract BTYCT is owned, TokenERC20 {
151 
152 	uint256 public totalSupply; //代币总量
153 	uint256 public decimals = 18; //代币小数点位数
154 	uint256 public sellPrice = 510; //出售价格 1枚代币换多少以太 /1000
155 	uint256 public buyPrice =  526; //购买价格 多少以太可购买1枚代币 /1000
156 	uint256 public sysPrice = 766 * 10 ** uint256(decimals); //挖矿的衡量值
157 	uint256 public sysPer = 225; //挖矿的增量百分比 /100
158 	
159 	//uint256 public onceOuttime = 86400; //增量的时间 正式 
160 	//uint256 public onceAddTime = 864000; //挖矿的时间 正式
161 	//uint256 public onceoutTimePer = 8640000; //增量的百分比 正式
162 	
163 	uint256 public onceOuttime = 120; //增量的时间 测试  
164 	uint256 public onceAddTime = 600; //挖矿的时间 测试
165 	uint256 public onceoutTimePer = 12000; //增量的百分比 测试
166 
167 	/* 冻结账户 */
168 	mapping(address => bool) public frozenAccount;
169 	// 记录各个账户的冻结数目
170 	mapping(address => uint256) public freezeOf;
171 	// 记录各个账户的可用数目
172 	mapping(address => uint256) public canOf;
173 	// 记录各个账户的释放时间
174 	mapping(address => uint) public cronoutOf;
175 	// 记录各个账户的增量时间
176 	mapping(address => uint) public cronaddOf;
177 
178 	/* 通知 */
179 	event FrozenFunds(address target, bool frozen);
180 	//event Logs (string);
181 	/* 构造函数 */
182 
183 	function BTYCT(
184 		uint256 initialSupply,
185 		string tokenName,
186 		string tokenSymbol
187 	) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
188 
189 	/* 转账， 比父类加入了账户冻结 */
190 	function _transfer(address _from, address _to, uint _value) internal {
191 		require(_to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
192 		require(canOf[_from] >= _value);
193 		require(balanceOf[_from] >= _value); // Check if the sender has enough
194 
195 		require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
196 		require(!frozenAccount[_from]); // Check if sender is frozen
197 		require(!frozenAccount[_to]); // Check if recipient is frozen
198 
199 		//挖矿 
200 		if(cronaddOf[_from] < 1) {
201 			cronaddOf[_from] = now + onceAddTime;
202 		}
203 		if(cronaddOf[_to] < 1) {
204 			cronaddOf[_to] = now + onceAddTime;
205 		}
206 		//释放 
207 		if(cronoutOf[_to] < 1) {
208 			cronoutOf[_to] = now + onceOuttime;
209 		}
210 		if(cronoutOf[_to] < 1) {
211 			cronoutOf[_to] = now + onceOuttime;
212 		}
213 		//if(freezeOf[_from] > 0) {
214 		uint lefttime = now - cronoutOf[_from];
215 		if(lefttime > onceOuttime) {
216 			uint leftper = lefttime / onceoutTimePer;
217 			if(leftper > 1) {
218 				leftper = 1;
219 			}
220 			canOf[_from] = balanceOf[_from] * leftper;
221 			freezeOf[_from] = balanceOf[_from] - canOf[_from];
222 			cronoutOf[_from] = now + onceOuttime;
223 		}
224 
225 		
226 		uint lefttimes = now - cronoutOf[_to];
227 		if(lefttimes >= onceOuttime) {
228 			uint leftpers = lefttime / onceoutTimePer;
229 			if(leftpers > 1) {
230 				leftpers = 1;
231 			}
232 			canOf[_to] = balanceOf[_to] * leftpers;
233 			freezeOf[_to] = balanceOf[_to] - canOf[_to];
234 			cronoutOf[_to] = now + onceOuttime;
235 		}
236 	
237 
238 		balanceOf[_from] -= _value; // Subtract from the sender
239 		balanceOf[_to] += _value;
240 		//减少可用
241 
242 		canOf[_from] -= _value;
243 		freezeOf[_from] = balanceOf[_from] - canOf[_from];
244 
245 		//增加冻结 
246 		freezeOf[_to] += _value;
247 		canOf[_to] = balanceOf[_to] - freezeOf[_to];
248 
249 		emit Transfer(_from, _to, _value);
250 	}
251 
252 	//获取可用数目
253 	function getcan(address target) public returns (uint256 _value) {
254 	    if(cronoutOf[target] < 1) {
255 	        _value = 0;
256 	    }else{
257 	        uint lefttime = now - cronoutOf[target];
258 	        uint leftnum = lefttime/onceoutTimePer;
259 	        if(leftnum > 1){
260 	            leftnum = 1;
261 	        }
262 	        _value = balanceOf[target]*leftnum;
263 	    }
264 	}
265 	
266 	/// 向指定账户拨发资金
267 	function mintToken(address target, uint256 mintedAmount) onlyOwner public {
268 		require(!frozenAccount[target]);
269 		balanceOf[target] += mintedAmount;
270 		balanceOf[this] -= mintedAmount;
271 		
272 		cronoutOf[target] = now + onceOuttime;
273 		cronaddOf[target] = now + onceAddTime;
274 		freezeOf[target] = balanceOf[target] + mintedAmount;
275 		
276 		emit Transfer(0, this, mintedAmount);
277 		emit Transfer(this, target, mintedAmount);
278 
279 	}
280 	//用户每隔10天挖矿一次
281 	function mint() public {
282 		require(!frozenAccount[msg.sender]);
283 		require(cronaddOf[msg.sender] > 0 && now > cronaddOf[msg.sender] && balanceOf[msg.sender] >= sysPrice);
284 		uint256 mintAmount = balanceOf[msg.sender] * sysPer / 10000;
285 		balanceOf[msg.sender] += mintAmount;
286 		balanceOf[this] -= mintAmount;
287 		
288 		freezeOf[msg.sender] = balanceOf[msg.sender] + mintAmount;
289 		cronaddOf[msg.sender] = now + onceAddTime;
290 		
291 		emit Transfer(0, this, mintAmount);
292 		emit Transfer(this, msg.sender, mintAmount);
293 
294 	}
295 
296 	/// 冻结 or 解冻账户
297 	function freezeAccount(address target, bool freeze) onlyOwner public {
298 		frozenAccount[target] = freeze;
299 		emit FrozenFunds(target, freeze);
300 	}
301 	// 设置销售购买价格
302 	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
303 		sellPrice = newSellPrice;
304 		buyPrice = newBuyPrice;
305 
306 	}
307 	//设置挖矿参数
308 	function setmyPrice(uint256 systyPrice, uint256 sysPermit) onlyOwner public {
309 		sysPrice = systyPrice;
310 		sysPer = sysPermit;
311 	}
312 	// 购买
313 	function buy() payable public returns(uint256 amount) {
314 	    require(!frozenAccount[msg.sender]);
315 		require(buyPrice > 0 && msg.value > buyPrice); // Avoid dividing 0, sending small amounts and spam
316 		amount = msg.value / (buyPrice/1000); // Calculate the amount of Dentacoins
317 		require(balanceOf[this] >= amount); // checks if it has enough to sell
318 		balanceOf[msg.sender] += amount; // adds the amount to buyer's balance
319 		balanceOf[this] -= amount; // subtracts amount from seller's balance
320 		emit Transfer(this, msg.sender, amount); // execute an event reflecting the change
321 		return amount; // ends function and returns
322 	}
323 
324 	// 出售
325 	function sell(uint256 amount) public returns(uint revenue) {
326 	    require(!frozenAccount[msg.sender]);
327 		require(sellPrice > 0); // Avoid selling and spam
328 		require(balanceOf[msg.sender] >= amount); // checks if the sender has enough to sell
329 		if(cronoutOf[msg.sender] < 1) {
330 			cronoutOf[msg.sender] = now + onceOuttime;
331 		}
332 		uint lefttime = now - cronoutOf[msg.sender];
333 		if(lefttime > onceOuttime) {
334 			uint leftper = lefttime / onceoutTimePer;
335 			if(leftper > 1) {
336 				leftper = 1;
337 			}
338 			canOf[msg.sender] = balanceOf[msg.sender] * leftper;
339 			freezeOf[msg.sender] = balanceOf[msg.sender] - canOf[msg.sender];
340 			cronoutOf[msg.sender] = now + onceOuttime;
341 		}
342 		require(canOf[msg.sender] >= amount);
343 		balanceOf[this] += amount; // adds the amount to owner's balance
344 		balanceOf[msg.sender] -= amount; // subtracts the amount from seller's balance
345 		revenue = amount * sellPrice/1000;
346 		require(msg.sender.send(revenue)); // sends ether to the seller: it's important to do this last to prevent recursion attacks
347 		emit Transfer(msg.sender, this, amount); // executes an event reflecting on the change
348 		return revenue;
349 
350 	}
351 
352 }
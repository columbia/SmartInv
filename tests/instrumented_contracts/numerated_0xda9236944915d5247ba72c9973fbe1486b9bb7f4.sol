1 pragma solidity ^ 0.4 .24;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7 	function add(uint a, uint b) internal pure returns(uint c) {
8 		c = a + b;
9 		require(c >= a);
10 	}
11 
12 	function sub(uint a, uint b) internal pure returns(uint c) {
13 		require(b <= a);
14 		c = a - b;
15 	}
16 
17 	function mul(uint a, uint b) internal pure returns(uint c) {
18 		c = a * b;
19 		require(a == 0 || c / a == b);
20 	}
21 
22 	function div(uint a, uint b) internal pure returns(uint c) {
23 		require(b > 0);
24 		c = a / b;
25 	}
26 }
27 
28 // ----------------------------------------------------------------------------
29 // ERC Token Standard #20 Interface
30 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
31 // ----------------------------------------------------------------------------
32 contract ERC20Interface {
33 	function totalSupply() public constant returns(uint);
34 
35 	function balanceOf(address tokenOwner) public constant returns(uint balance);
36 
37 	function allowance(address tokenOwner, address spender) public constant returns(uint remaining);
38 
39 	function transfer(address to, uint tokens) public returns(bool success);
40 
41 	function approve(address spender, uint tokens) public returns(bool success);
42 
43 	function transferFrom(address from, address to, uint tokens) public returns(bool success);
44 
45 	event Transfer(address indexed from, address indexed to, uint tokens);
46 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
47 }
48 
49 // ----------------------------------------------------------------------------
50 // Contract function to receive approval and execute function in one call
51 //
52 // Borrowed from MiniMeToken
53 // ----------------------------------------------------------------------------
54 contract ApproveAndCallFallBack {
55 	function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
56 }
57 
58 // ----------------------------------------------------------------------------
59 // Owned contract
60 // ----------------------------------------------------------------------------
61 contract Owned {
62 	address public owner;
63 	address public newOwner;
64 
65 	event OwnershipTransferred(address indexed _from, address indexed _to);
66 
67 	constructor() public {
68 		owner = msg.sender;
69 	}
70 
71 	modifier onlyOwner {
72 		require(msg.sender == owner);
73 		_;
74 	}
75 
76 	function transferOwnership(address _newOwner) public onlyOwner {
77 		newOwner = _newOwner;
78 	}
79 
80 	function acceptOwnership() public {
81 		require(msg.sender == newOwner);
82 		emit OwnershipTransferred(owner, newOwner);
83 		owner = newOwner;
84 		newOwner = address(0);
85 	}
86 }
87 
88 // ----------------------------------------------------------------------------
89 // ERC20 Token, with the addition of symbol, name and decimals and a
90 // fixed supply
91 // ----------------------------------------------------------------------------
92 contract BTYCToken is ERC20Interface, Owned {
93 	using SafeMath
94 	for uint;
95 
96 	string public symbol;
97 	string public name;
98 	uint8 public decimals;
99 	uint _totalSupply;
100 
101 	uint256 public sellPrice; //出售价格 1枚代币换多少以太 /1000
102 	uint256 public buyPrice; //购买价格 多少以太可购买1枚代币 /1000
103 	uint256 public sysPrice; //挖矿的衡量值
104 	uint256 public sysPer; //挖矿的增量百分比 /100
105 
106 	uint256 public onceOuttime; //增量的时间 测试  
107 	uint256 public onceAddTime; //挖矿的时间 测试
108 
109 	mapping(address => uint) balances;
110 	mapping(address => mapping(address => uint)) allowed;
111 
112 	/* 冻结账户 */
113 	mapping(address => bool) public frozenAccount;
114 	// 记录各个账户的冻结数目
115 	//mapping(address => uint256) public freezeOf;
116 	// 记录各个账户的可用数目
117 	//mapping(address => uint256) public canOf;
118 	struct roundsOwn {
119 		uint256 addtime; // 添加时间
120 		uint256 addmoney; // 金额
121 	}
122 	mapping(address => roundsOwn[]) public mycan;
123     mapping(address => uint256) public tradenum;
124 	// 记录各个账户的释放时间
125 	//mapping(address => uint) public cronoutOf;
126 	// 记录各个账户的增量时间
127 	mapping(address => uint) public cronaddOf;
128 
129 	/* 通知 */
130 	event FrozenFunds(address target, bool frozen);
131 	// ------------------------------------------------------------------------
132 	// Constructor
133 	// ------------------------------------------------------------------------
134 	constructor() public {
135 
136 		symbol = "BTYC";
137 		name = "BTYC Coin";
138 		decimals = 18;
139 		_totalSupply = 84000000 * 10 ** uint(decimals);
140 
141 		sellPrice = 510; //出售价格 1枚代币换多少以太 /1000000
142 		buyPrice = 526; //购买价格 多少以太可购买1枚代币 /1000000
143 		sysPrice = 766; //挖矿的衡量值
144 		sysPer = 225; //挖矿的增量百分比 /100
145 
146 		onceOuttime = 86400; //增量的时间 正式 
147 		onceAddTime = 864000; //挖矿的时间 正式
148 
149 		//onceOuttime = 10; //增量的时间 测试  
150 		//onceAddTime = 10; //挖矿的时间 测试
151 		balances[owner] = _totalSupply;
152 		emit Transfer(address(0), owner, _totalSupply);
153 
154 	}
155 
156 	// ------------------------------------------------------------------------
157 	// Get the token balance for account `tokenOwner`
158 	// ------------------------------------------------------------------------
159 
160 	function balanceOf(address tokenOwner) public view returns(uint balance) {
161 		return balances[tokenOwner];
162 	}
163 
164 	function addmoney(address _addr, uint256 _money) private{
165 	    roundsOwn stateVar;
166 	    uint256 _now = now;
167 	    stateVar.addtime = _now;
168 	    stateVar.addmoney = _money;
169 		mycan[_addr].push(stateVar);
170 		tradenum[_addr] = tradenum[_addr] + 1;
171 	}
172 
173 
174 	function getcanuse(address tokenOwner) public view returns(uint balance) {
175 	    uint256 _now = now;
176 	    uint256 _left = 0;
177 	    for(uint256 i = 0; i < tradenum[tokenOwner]; i++) {
178 	        roundsOwn mydata = mycan[tokenOwner][i];
179 	        uint256 stime = mydata.addtime;
180 	        uint256 smoney = mydata.addmoney;
181 	        uint256 lefttimes = _now - stime;
182 	        if(lefttimes >= onceOuttime) {
183 	            uint256 leftpers = lefttimes / onceOuttime;
184 	            if(leftpers > 100){
185 	                leftpers = 100;
186 	            }
187 	            _left = smoney*leftpers/100 + _left;
188 	        }
189 	    }
190 	    return(_left);
191 	}
192 
193 	// ------------------------------------------------------------------------
194 	// Transfer the balance from token owner's account to `to` account
195 	// - Owner's account must have sufficient balance to transfer
196 	// - 0 value transfers are allowed
197 	// ------------------------------------------------------------------------
198 	function transfer(address to, uint tokens) public returns(bool success) {
199 		require(!frozenAccount[msg.sender]);
200 		require(!frozenAccount[to]);
201 		uint256 canuse = getcanuse(msg.sender);
202 		require(canuse >= tokens);
203 		//canOf[msg.sender] = myuseOf(msg.sender);
204 		//canOf[msg.sender] = canOf[msg.sender].sub(tokens);
205 		balances[msg.sender] = balances[msg.sender].sub(tokens);
206 		balances[to] = balances[to].add(tokens);
207 		addmoney(to, tokens);
208 		emit Transfer(msg.sender, to, tokens);
209 		return true;
210 	}
211 	/*
212 	function buytoken(address user, uint256 amount) public{
213 	    balances[user] = balances[user].sub(amount);
214 	    //buyeth(amount);
215 	    emit Transfer(address(0), user, amount);
216 	}*/
217 
218 	// ------------------------------------------------------------------------
219 	// Token owner can approve for `spender` to transferFrom(...) `tokens`
220 	// from the token owner's account
221 	//
222 	// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
223 	// recommends that there are no checks for the approval double-spend attack
224 	// as this should be implemented in user interfaces 
225 	// ------------------------------------------------------------------------
226 	function approve(address spender, uint tokens) public returns(bool success) {
227 		allowed[msg.sender][spender] = tokens;
228 		emit Approval(msg.sender, spender, tokens);
229 		return true;
230 	}
231 
232 	// ------------------------------------------------------------------------
233 	// Transfer `tokens` from the `from` account to the `to` account
234 	// 
235 	// The calling account must already have sufficient tokens approve(...)-d
236 	// for spending from the `from` account and
237 	// - From account must have sufficient balance to transfer
238 	// - Spender must have sufficient allowance to transfer
239 	// - 0 value transfers are allowed
240 	// ------------------------------------------------------------------------
241 	function transferFrom(address from, address to, uint tokens) public returns(bool success) {
242 		balances[from] = balances[from].sub(tokens);
243 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
244 		balances[to] = balances[to].add(tokens);
245 		emit Transfer(from, to, tokens);
246 		return true;
247 	}
248 
249 	// ------------------------------------------------------------------------
250 	// Returns the amount of tokens approved by the owner that can be
251 	// transferred to the spender's account
252 	// ------------------------------------------------------------------------
253 	function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
254 		return allowed[tokenOwner][spender];
255 	}
256 
257 	// ------------------------------------------------------------------------
258 	// Token owner can approve for `spender` to transferFrom(...) `tokens`
259 	// from the token owner's account. The `spender` contract function
260 	// `receiveApproval(...)` is then executed
261 	// ------------------------------------------------------------------------
262 	function approveAndCall(address spender, uint tokens, bytes data) public returns(bool success) {
263 		allowed[msg.sender][spender] = tokens;
264 		emit Approval(msg.sender, spender, tokens);
265 		ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
266 		return true;
267 	}
268 
269 	/// 冻结 or 解冻账户
270 	function freezeAccount(address target, bool freeze) onlyOwner public {
271 		frozenAccount[target] = freeze;
272 		emit FrozenFunds(target, freeze);
273 	}
274 	// 设置销售购买价格
275 	function setPrices(uint256 newBuyPrice, uint256 newSellPrice, uint256 systyPrice, uint256 sysPermit) onlyOwner public {
276 		buyPrice = newBuyPrice;
277 		sellPrice = newSellPrice;
278 		sysPrice = systyPrice;
279 		sysPer = sysPermit;
280 	}
281 	// 获取价格 
282 	function getprice() public view returns(uint256 bprice, uint256 spice, uint256 sprice, uint256 sper) {
283 		bprice = buyPrice;
284 		spice = sellPrice;
285 		sprice = sysPrice;
286 		sper = sysPer;
287 	}
288 
289 	// ------------------------------------------------------------------------
290 	// Total supply
291 	// ------------------------------------------------------------------------
292 	function totalSupply() public view returns(uint) {
293 		return _totalSupply.sub(balances[address(0)]);
294 	}
295 	/// 向指定账户拨发资金
296 	function mintToken(address target, uint256 mintedAmount) onlyOwner public {
297 		require(!frozenAccount[target]);
298         if(cronaddOf[msg.sender] < 1) {
299 			cronaddOf[msg.sender] = now + onceAddTime;
300 		}
301 		balances[target] += mintedAmount;
302 		//_totalSupply -= mintedAmount;
303 		addmoney(target, mintedAmount);
304 		//emit Transfer(0, this, mintedAmount);
305 		emit Transfer(this, target, mintedAmount);
306 
307 	}
308 	//用户每隔10天挖矿一次
309 	function mintme() public {
310 		require(!frozenAccount[msg.sender]);
311 		require(now > cronaddOf[msg.sender]);
312 		uint256 mintAmount = balances[msg.sender] * sysPer / 10000;
313 		balances[msg.sender] += mintAmount;
314 		//_totalSupply -= mintAmount;
315 		cronaddOf[msg.sender] = now + onceAddTime;
316 		addmoney(msg.sender, mintAmount);
317 		//emit Transfer(0, this, mintAmount);
318 		emit Transfer(this, msg.sender, mintAmount);
319 
320 	}
321     
322 	function buy(uint256 money) public payable returns(uint256 amount) {
323 		require(!frozenAccount[msg.sender]);
324 		amount = money * buyPrice;
325 		balances[msg.sender] += amount;
326 		balances[this] -= amount;  
327 		//_totalSupply -= amount;
328 		addmoney(msg.sender, amount);
329 		//msg.sender.transfer(money);
330 		emit Transfer(this, msg.sender, amount); 
331 		return(amount);
332 	}
333 
334 	function() payable public {
335 		buy(msg.value);
336 	}
337 	/*
338 	function selleth(uint amount) public payable {
339 	    //address user = msg.sender;
340 	    //canOf[user] = myuseOf(user);
341 	    //require(balances[user] >= amount );
342 	    //uint money = amount * sellPrice;
343 	   // balances[msg.sender] += money;
344 	    owner.transfer(amount);
345 	}*/
346 
347 	function sell(uint256 amount) public returns(bool success) {
348 		//address user = msg.sender;
349 		//canOf[msg.sender] = myuseOf(msg.sender);
350 		//require(!frozenAccount[msg.sender]);
351 		uint256 canuse = getcanuse(msg.sender);
352 		require(canuse >= amount);
353 		uint moneys = amount / sellPrice;
354 		require(msg.sender.send(moneys));
355 		balances[msg.sender] -= amount;
356 		balances[this] += amount;
357 		//_totalSupply += amount;
358 		//canOf[msg.sender] -= amount;
359 		
360 		//this.transfer(moneys);Transfer(this, msg.sender, revenue);  
361 		emit Transfer(this, msg.sender, moneys);
362 		//canOf[user] -= amount;
363 		return(true);
364 	}
365 
366 }
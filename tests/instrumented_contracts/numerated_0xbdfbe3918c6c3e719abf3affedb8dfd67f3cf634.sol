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
101 	uint public sellPrice; //出售价格 1枚代币换多少以太 /1000
102 	uint public buyPrice; //购买价格 多少以太可购买1枚代币 /1000
103 	uint public sysPrice; //挖矿的衡量值
104 	uint8 public sysPer; //挖矿的增量百分比 /100
105 	uint public givecandyto; //奖励新人 
106 	uint public givecandyfrom; //奖励推荐人
107 	uint public candyper; //转账多少给奖励
108 	//uint sysPricetrue;
109 
110 	uint public onceOuttime; //增量的时间 测试  
111 	uint public onceAddTime; //挖矿的时间 测试
112 
113 	mapping(address => uint) balances;
114 	mapping(address => uint) used;
115 	mapping(address => mapping(address => uint)) allowed;
116 
117 	/* 冻结账户 */
118 	mapping(address => bool) public frozenAccount;
119 	// 记录各个账户的冻结数目
120 	//mapping(address => uint256) public freezeOf;
121 	// 记录各个账户的可用数目
122 	//mapping(address => uint256) public canOf;
123 	/*
124 	struct roundsOwn {
125 		uint256 addtime; // 添加时间
126 		uint256 addmoney; // 金额
127 	}*/
128 	//释放 
129 	mapping(address => uint[]) public mycantime;
130 	mapping(address => uint[]) public mycanmoney;
131 	
132 	mapping(address => address) public fromaddr;
133     //mapping(address => uint256) public tradenum;
134 	// 记录各个账户的释放时间
135 	//mapping(address => uint) public cronoutOf;
136 	// 记录各个账户的增量时间
137 	mapping(address => uint) public cronaddOf;
138 
139 	/* 通知 */
140 	event FrozenFunds(address target, bool frozen);
141 	// ------------------------------------------------------------------------
142 	// Constructor
143 	// ------------------------------------------------------------------------
144 	constructor() public {
145 
146 		symbol = "BTYC";
147 		name = "BTYC Coin";
148 		decimals = 18;
149 		_totalSupply = 86400000 ether;
150 
151 		sellPrice = 510 szabo; //出售价格 1枚代币换多少以太 /1000000
152 		buyPrice = 526 szabo; //购买价格 多少以太可购买1枚代币 /1000000
153 		sysPrice = 766 ether; //挖矿的衡量值
154 		sysPer = 225; //挖矿的增量百分比 /100
155 		candyper = 1 ether;
156 		givecandyfrom = 10 ether;
157 		givecandyto = 40 ether;
158 
159 		//onceOuttime = 1 days; //增量的时间 正式 
160 		//onceAddTime = 10 days; //挖矿的时间 正式
161 
162 		onceOuttime = 10 seconds; //增量的时间 测试  
163 		onceAddTime = 20 seconds; //挖矿的时间 测试
164 		balances[owner] = _totalSupply;
165 		emit Transfer(address(0), owner, _totalSupply);
166 
167 	}
168 
169 	// ------------------------------------------------------------------------
170 	// Get the token balance for account `tokenOwner`
171 	// ------------------------------------------------------------------------
172 
173 	function balanceOf(address tokenOwner) public view returns(uint balance) {
174 		return balances[tokenOwner];
175 	}
176 
177 	function addmoney(address _addr, uint256 _money) private{
178 	    uint256 _now = now;
179 	    mycanmoney[_addr].push(_money);
180 	    mycantime[_addr].push(_now);
181 	    /*
182 	    roundsOwn storage stateVar;
183 	    uint256 _now = now;
184 	    stateVar.addtime = _now;
185 	    stateVar.addmoney = _money;
186 		mycan[_addr].push(stateVar);*/
187 		if(balances[_addr] >= sysPrice && cronaddOf[_addr] < 1) {
188 			cronaddOf[_addr] = now + onceAddTime;
189 		}
190 		//tradenum[_addr] = tradenum[_addr] + 1;
191 	}
192 	function reducemoney(address _addr, uint256 _money) private{
193 	    used[_addr] += _money;
194 	    if(balances[_addr] < sysPrice){
195 	        cronaddOf[_addr] = 0;
196 	    }
197 	}
198     function getaddtime(address _addr) public view returns(uint) {
199         if(cronaddOf[_addr] < 1) {
200 			return(now + onceAddTime);
201 		}
202 		return(cronaddOf[_addr]);
203     }
204 
205 	function getcanuse(address tokenOwner) public view returns(uint balance) {
206 	    uint256 _now = now;
207 	    uint256 _left = 0;
208 	    for(uint256 i = 0; i < mycantime[tokenOwner].length; i++) {
209 	        //roundsOwn mydata = mycan[tokenOwner][i];
210 	        uint256 stime = mycantime[tokenOwner][i];
211 	        uint256 smoney = mycanmoney[tokenOwner][i];
212 	        uint256 lefttimes = _now - stime;
213 	        if(lefttimes >= onceOuttime) {
214 	            uint256 leftpers = lefttimes / onceOuttime;
215 	            if(leftpers > 100){
216 	                leftpers = 100;
217 	            }
218 	            _left = smoney*leftpers/100 + _left;
219 	        }
220 	    }
221 	    _left = _left - used[tokenOwner];
222 	    if(_left < 0){
223 	        return(0);
224 	    }
225 	    if(_left > balances[tokenOwner]){
226 	        return(balances[tokenOwner]);
227 	    }
228 	    return(_left);
229 	}
230 
231 	// ------------------------------------------------------------------------
232 	// Transfer the balance from token owner's account to `to` account
233 	// - Owner's account must have sufficient balance to transfer
234 	// - 0 value transfers are allowed
235 	// ------------------------------------------------------------------------
236 	function transfer(address to, uint tokens) public returns(bool success) {
237 		require(!frozenAccount[msg.sender]);
238 		require(!frozenAccount[to]);
239 		uint256 canuse = getcanuse(msg.sender);
240 		require(canuse >= tokens);
241 
242 		if(fromaddr[to] == address(0)){
243 		    fromaddr[to] = msg.sender;
244 		    
245     		if(tokens >= candyper) {
246     		    if(givecandyfrom > 0) {
247     		        balances[msg.sender] = balances[msg.sender].sub(tokens).add(givecandyfrom);
248     		        reducemoney(msg.sender, tokens);
249     		        addmoney(msg.sender, givecandyfrom);
250     		    }
251     		    if(givecandyto > 0) {
252     		        tokens += givecandyto;
253     		    }
254     		}else{
255     		    reducemoney(msg.sender, tokens);
256     		    balances[msg.sender] = balances[msg.sender].sub(tokens);
257     		}
258     		balances[to] = balances[to].add(tokens);
259     		addmoney(to, tokens);
260 		    //tokens = candyuser(msg.sender, to, tokens);
261 		}else{
262 		    reducemoney(msg.sender, tokens);
263     		balances[msg.sender] = balances[msg.sender].sub(tokens);
264     		balances[to] = balances[to].add(tokens);
265     		addmoney(to, tokens);
266 		}
267 		emit Transfer(msg.sender, to, tokens);
268 		return true;
269 	}
270 	/*
271 	function candyuser(address from, address to, uint tokens) private returns(uint money){
272 	     money = tokens;
273 	    if(tokens >= candyper) {
274 		        if(givecandyto > 0) {
275     		        balances[to] = balances[to].add(givecandyto);
276     		        addmoney(to, givecandyto);
277     		        money = tokens + givecandyto;
278     		    }
279     		    if(givecandyfrom > 0) {
280     		        balances[from] = balances[from].add(givecandyfrom);
281     		        addmoney(from, givecandyfrom);
282     		    }
283 		    }
284 	}*/
285 	function getnum(uint num) public view returns(uint){
286 	    return(num* 10 ** uint(decimals));
287 	}
288 	function getfrom(address _addr) public view returns(address) {
289 	    return(fromaddr[_addr]);
290 	    //return(address(0));
291 	}
292 	/*
293 	function buytoken(address user, uint256 amount) public{
294 	    balances[user] = balances[user].sub(amount);
295 	    //buyeth(amount);
296 	    emit Transfer(address(0), user, amount);
297 	}*/
298 
299 	// ------------------------------------------------------------------------
300 	// Token owner can approve for `spender` to transferFrom(...) `tokens`
301 	// from the token owner's account
302 	//
303 	// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
304 	// recommends that there are no checks for the approval double-spend attack
305 	// as this should be implemented in user interfaces 
306 	// ------------------------------------------------------------------------
307 	function approve(address spender, uint tokens) public returns(bool success) {
308 		allowed[msg.sender][spender] = tokens;
309 		emit Approval(msg.sender, spender, tokens);
310 		return true;
311 	}
312 
313 	// ------------------------------------------------------------------------
314 	// Transfer `tokens` from the `from` account to the `to` account
315 	// 
316 	// The calling account must already have sufficient tokens approve(...)-d
317 	// for spending from the `from` account and
318 	// - From account must have sufficient balance to transfer
319 	// - Spender must have sufficient allowance to transfer
320 	// - 0 value transfers are allowed
321 	// ------------------------------------------------------------------------
322 	function transferFrom(address from, address to, uint tokens) public returns(bool success) {
323 		balances[from] = balances[from].sub(tokens);
324 		reducemoney(from, tokens);
325 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
326 		balances[to] = balances[to].add(tokens);
327 		addmoney(to, tokens);
328 		emit Transfer(from, to, tokens);
329 		return true;
330 	}
331 
332 	// ------------------------------------------------------------------------
333 	// Returns the amount of tokens approved by the owner that can be
334 	// transferred to the spender's account
335 	// ------------------------------------------------------------------------
336 	function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
337 		return allowed[tokenOwner][spender];
338 	}
339 
340 	// ------------------------------------------------------------------------
341 	// 授权
342 	// ------------------------------------------------------------------------
343 	function approveAndCall(address spender, uint tokens, bytes data) public returns(bool success) {
344 		allowed[msg.sender][spender] = tokens;
345 		emit Approval(msg.sender, spender, tokens);
346 		ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
347 		return true;
348 	}
349 
350 	/// 冻结 or 解冻账户
351 	function freezeAccount(address target, bool freeze) onlyOwner public {
352 		frozenAccount[target] = freeze;
353 		emit FrozenFunds(target, freeze);
354 	}
355 	// 设置销售购买价格
356 	function setPrices(uint newBuyPrice, uint newSellPrice, uint systyPrice, uint8 sysPermit, uint sysgivefrom, uint sysgiveto, uint sysgiveper) onlyOwner public {
357 		buyPrice = newBuyPrice;
358 		sellPrice = newSellPrice;
359 		sysPrice = systyPrice;
360 		sysPer = sysPermit;
361 		givecandyfrom = sysgivefrom;
362 		givecandyto = sysgiveto;
363 		candyper = sysgiveper;
364 	}
365 	// 获取价格 
366 	function getprice() public view returns(uint bprice, uint spice, uint sprice, uint8 sper, uint givefrom, uint giveto, uint giveper) {
367 		bprice = buyPrice;
368 		spice = sellPrice;
369 		sprice = sysPrice;
370 		sper = sysPer;
371 		givefrom = givecandyfrom;
372 		giveto = givecandyto;
373 		giveper = candyper;
374 	}
375 
376 	// ------------------------------------------------------------------------
377 	// Total supply
378 	// ------------------------------------------------------------------------
379 	function totalSupply() public view returns(uint) {
380 		return _totalSupply.sub(balances[address(0)]);
381 	}
382 	/// 向指定账户拨发资金
383 	function mintToken(address target, uint256 mintedAmount) onlyOwner public {
384 		require(!frozenAccount[target]);
385         
386 		balances[target] += mintedAmount;
387 		//_totalSupply -= mintedAmount;
388 		addmoney(target, mintedAmount);
389 		//emit Transfer(0, this, mintedAmount);
390 		emit Transfer(this, target, mintedAmount);
391 
392 	}
393 	//用户每隔10天挖矿一次
394 	function mint() public {
395 		require(!frozenAccount[msg.sender]);
396 		require(cronaddOf[msg.sender] > 0);
397 		require(now > cronaddOf[msg.sender]);
398 		require(balances[msg.sender] >= getnum(sysPrice));
399 		uint256 mintAmount = balances[msg.sender] * sysPer / 10000;
400 		balances[msg.sender] += mintAmount;
401 		//_totalSupply -= mintAmount;
402 		cronaddOf[msg.sender] = now + onceAddTime;
403 		addmoney(msg.sender, mintAmount);
404 		//emit Transfer(0, this, mintAmount);
405 		emit Transfer(this, msg.sender, mintAmount);
406 
407 	}
408     
409 	function buy(uint256 money) public payable returns(uint256 amount) {
410 		require(!frozenAccount[msg.sender]);
411 		amount = money * buyPrice;
412 		require(balances[this] > amount);
413 		balances[msg.sender] += amount;
414 		balances[this] -= amount;  
415 		//_totalSupply -= amount;
416 		addmoney(msg.sender, amount);
417 		//msg.sender.transfer(money);
418 		emit Transfer(this, msg.sender, amount); 
419 		return(amount);
420 	}
421 
422 	function() payable public {
423 		buy(msg.value);
424 	}
425 	
426 
427 	function sell(uint256 amount) public returns(bool success) {
428 		//address user = msg.sender;
429 		//canOf[msg.sender] = myuseOf(msg.sender);
430 		//require(!frozenAccount[msg.sender]);
431 		uint256 canuse = getcanuse(msg.sender);
432 		require(canuse >= amount);
433 		require(balances[msg.sender] > amount);
434 		uint moneys = amount / sellPrice;
435 		require(msg.sender.send(moneys));
436 		reducemoney(msg.sender, amount);
437 		balances[msg.sender] -= amount;
438 		balances[this] += amount;
439 		//_totalSupply += amount;
440 		//canOf[msg.sender] -= amount;
441 		
442 		//this.transfer(moneys);Transfer(this, msg.sender, revenue);  
443 		emit Transfer(this, msg.sender, moneys);
444 		//canOf[user] -= amount;
445 		return(true);
446 	}
447 
448 }
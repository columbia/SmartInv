1 pragma solidity ^ 0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 安全的加减乘除
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
59 // 管理员
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
89 // 核心类
90 // ----------------------------------------------------------------------------
91 contract IEVC is ERC20Interface, Owned {
92 	using SafeMath
93 	for uint;
94 
95 	string public symbol;
96 	string public name;
97 	uint8 public decimals;
98 	uint _totalSupply;
99 
100 	uint public sellPrice; //出售价格 1枚代币换多少以太 /1000
101 	uint public buyPrice; //购买价格 多少以太可购买1枚代币 /1000
102 	bool public actived;
103 
104 
105 	mapping(address => uint) balances;
106 	mapping(address => mapping(address => uint)) allowed;
107 
108 	/* 冻结账户 */
109 	mapping(address => bool) public frozenAccount;
110 
111 	//上家地址
112 	mapping(address => address) public fromaddr;
113 	//管理员帐号
114 	mapping(address => bool) public admins;
115 
116 	/* 通知 */
117 	event FrozenFunds(address target, bool frozen);
118 	// ------------------------------------------------------------------------
119 	// Constructor
120 	// ------------------------------------------------------------------------
121 	constructor() public {
122 
123 		symbol = "IEVC";
124 		name = "IEVC Coin";
125 		decimals = 18;
126 		_totalSupply = 1000000000 ether;
127 
128 		sellPrice = 1 ether; //出售价格 1token can buy how much eth
129 		buyPrice = 1 ether; //购买价格 1eth can buy how much token
130 		actived = true;
131 	
132 		balances[this] = _totalSupply;
133 		balances[owner] = _totalSupply;
134 		emit Transfer(this, owner, _totalSupply);
135 
136 	}
137 
138 	/* 获取用户金额 */
139 	function balanceOf(address tokenOwner) public view returns(uint balance) {
140 		return balances[tokenOwner];
141 	}
142 
143 	/*
144 	 * 用户转账
145 	 * @param {Object} address
146 	 */
147 	function transfer(address to, uint tokens) public returns(bool success) {
148 		require(!frozenAccount[msg.sender]);
149 		require(!frozenAccount[to]);
150 		require(actived == true);
151 		require(balances[msg.sender] >= tokens);
152 		require(msg.sender != to);
153 		require(to != 0x0);
154 		 // 检查是否溢出（数据类型的溢出）
155         require(balances[to] + tokens > balances[to]);
156         // 将此保存为将来的断言， 函数最后会有一个检验
157         uint previousBalances = balances[msg.sender] + balances[to];
158 		//如果用户没有上家
159 		if(fromaddr[to] == address(0)) {
160 			//指定上家地址
161 			fromaddr[to] = msg.sender;
162 		} 
163 
164 		balances[msg.sender] = balances[msg.sender].sub(tokens);
165 		balances[to] = balances[to].add(tokens);
166 		emit Transfer(msg.sender, to, tokens);
167 		// 断言检测， 不应该为错
168         assert(balances[msg.sender] + balances[to] == previousBalances);
169 		return true;
170 	}
171 	
172 	/*
173 	 * 获取上家地址
174 	 * @param {Object} address
175 	 */
176 	function getfrom(address _addr) public view returns(address) {
177 		return(fromaddr[_addr]);
178 	}
179 
180 	function approve(address spender, uint tokens) public returns(bool success) {
181 		require(admins[msg.sender] == true);
182 		allowed[msg.sender][spender] = tokens;
183 		emit Approval(msg.sender, spender, tokens);
184 		return true;
185 	}
186 	/*
187 	 * 授权转账
188 	 * @param {Object} address
189 	 */
190 	function transferFrom(address from, address to, uint tokens) public returns(bool success) {
191 		require(actived == true);
192 		require(!frozenAccount[from]);
193 		require(!frozenAccount[to]);
194 		balances[from] = balances[from].sub(tokens);
195 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
196 		balances[to] = balances[to].add(tokens);
197 		emit Transfer(from, to, tokens);
198 		return true;
199 	}
200 
201 	/*
202 	 * 获取授权信息
203 	 * @param {Object} address
204 	 */
205 	function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
206 		return allowed[tokenOwner][spender];
207 	}
208 
209 	/*
210 	 * 授权
211 	 * @param {Object} address
212 	 */
213 	function approveAndCall(address spender, uint tokens, bytes data) public returns(bool success) {
214 		allowed[msg.sender][spender] = tokens;
215 		emit Approval(msg.sender, spender, tokens);
216 		ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
217 		return true;
218 	}
219 
220 	/// 冻结 or 解冻账户
221 	function freezeAccount(address target, bool freeze) public {
222 		require(admins[msg.sender] == true);
223 		frozenAccount[target] = freeze;
224 		emit FrozenFunds(target, freeze);
225 	}
226 	/*
227 	 * 设置管理员
228 	 * @param {Object} address
229 	 */
230 	function admAccount(address target, bool freeze) onlyOwner public {
231 		admins[target] = freeze;
232 	}
233 	/*
234 	 * 系统设置
235 	 * @param {Object} uint
236 	 */
237 	function setPrices(uint newBuyPrice, uint newSellPrice) public {
238 		require(admins[msg.sender] == true);
239 		buyPrice = newBuyPrice;
240 		sellPrice = newSellPrice;
241 	}
242 	/*
243 	 * 获取系统设置
244 	 */
245 	function getprice() public view returns(uint bprice, uint spice) {
246 		bprice = buyPrice;
247 		spice = sellPrice;
248 		
249 	}
250 	/*
251 	 * 设置是否开启
252 	 * @param {Object} bool
253 	 */
254 	function setactive(bool tags) public onlyOwner {
255 		actived = tags;
256 	}
257 
258 	/*
259 	 * 获取总发行
260 	 */
261 	function totalSupply() public view returns(uint) {
262 		return _totalSupply.sub(balances[this]);
263 	}
264 	/*
265 	 * 向指定账户拨发资金
266 	 * @param {Object} address
267 	 */
268 	function mintToken(address target, uint256 mintedAmount) public {
269 		require(!frozenAccount[target]);
270 		require(admins[msg.sender] == true);
271 		require(actived == true);
272         require(balances[this] >= mintedAmount);
273 		balances[target] = balances[target].add(mintedAmount);
274 		balances[this] = balances[this].sub(mintedAmount);
275 		emit Transfer(this, target, mintedAmount);
276 
277 	}
278 	
279 	
280 	/*
281 	 * 购买
282 	 */
283 	function buy() public payable returns(uint) {
284 		require(actived == true);
285 		require(!frozenAccount[msg.sender]);
286 		require(msg.value > 0);
287 
288 		uint amount = msg.value * buyPrice/1 ether;
289 		require(balances[this] >= amount);
290 		balances[msg.sender] = balances[msg.sender].add(amount);
291 		balances[this] = balances[this].sub(amount);
292 		emit Transfer(owner, msg.sender, amount);
293 		return(amount);
294 	}
295 	/*
296 	 * 系统充值
297 	 */
298 	function charge() public payable returns(bool) {
299 		//require(actived == true);
300 		return(true);
301 	}
302 	
303 	function() payable public {
304 		buy();
305 	}
306 	/*
307 	 * 系统提现
308 	 * @param {Object} address
309 	 */
310 	function withdraw(address _to) public onlyOwner {
311 		require(actived == true);
312 		require(!frozenAccount[_to]);
313 		_to.transfer(address(this).balance);
314 	}
315 	/*
316 	 * 出售
317 	 * @param {Object} uint256
318 	 */
319 	function sell(uint256 amount) public returns(bool success) {
320 		require(actived == true);
321 		require(!frozenAccount[msg.sender]);
322 		require(amount > 0);
323 		require(balances[msg.sender] >= amount);
324 		//uint moneys = (amount * sellPrice) / 10 ** uint(decimals);
325 		uint moneys = amount * sellPrice/1 ether;
326 		require(address(this).balance >= moneys);
327 		msg.sender.transfer(moneys);
328 		balances[msg.sender] = balances[msg.sender].sub(amount);
329 		balances[this] = balances[this].add(amount);
330 
331 		emit Transfer(msg.sender, this, amount);
332 		return(true);
333 	}
334 	/*
335 	 * 批量发币
336 	 * @param {Object} address
337 	 */
338 	function addBalances(address[] recipients, uint256[] moenys) public{
339 		require(admins[msg.sender] == true);
340 		uint256 sum = 0;
341 		for(uint256 i = 0; i < recipients.length; i++) {
342 			balances[recipients[i]] = balances[recipients[i]].add(moenys[i]);
343 			emit Transfer(this, msg.sender, moenys[i]);
344 			sum = sum.add(moenys[i]);
345 		}
346 		balances[this] = balances[this].sub(sum);
347 	}
348 	/*
349 	 * 批量减币
350 	 * @param {Object} address
351 	 */
352 	function subBalances(address[] recipients, uint256[] moenys) public{
353 		require(admins[msg.sender] == true);
354 		uint256 sum = 0;
355 		for(uint256 i = 0; i < recipients.length; i++) {
356 			balances[recipients[i]] = balances[recipients[i]].sub(moenys[i]);
357 			emit Transfer(msg.sender, this, moenys[i]);
358 			sum = sum.add(moenys[i]);
359 		}
360 		balances[this] = balances[this].add(sum);
361 	}
362 
363 }
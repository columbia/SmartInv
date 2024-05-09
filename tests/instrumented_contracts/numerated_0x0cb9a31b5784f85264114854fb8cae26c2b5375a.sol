1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
29 // ----------------------------------------------------------------------------
30 contract ERC20Interface {
31     function totalSupply() public constant returns (uint);
32     function balanceOf(address tokenOwner) public constant returns (uint balance);
33     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 
43 // ----------------------------------------------------------------------------
44 // Contract function to receive approval and execute function in one call
45 //
46 // Borrowed from MiniMeToken
47 // ----------------------------------------------------------------------------
48 contract ApproveAndCallFallBack {
49     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Owned contract
55 // ----------------------------------------------------------------------------
56 contract Owned {
57     address public owner;
58     address public newOwner;
59 
60     event OwnershipTransferred(address indexed _from, address indexed _to);
61 
62     constructor() public {
63         owner = msg.sender;
64     }
65 
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     function transferOwnership(address _newOwner) public onlyOwner {
72         newOwner = _newOwner;
73     }
74     function acceptOwnership() public {
75         require(msg.sender == newOwner);
76         emit OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         newOwner = address(0);
79     }
80 }
81 
82 
83 // ----------------------------------------------------------------------------
84 // ERC20 Token, with the addition of symbol, name and decimals and a
85 // fixed supply
86 // ----------------------------------------------------------------------------
87 contract BTYCToken is ERC20Interface, Owned {
88      using SafeMath for uint;
89     /*
90     string public symbol;
91     string public  name;
92     uint8 public decimals;
93     uint _totalSupply;*/
94 
95     uint256 public sellPrice; //出售价格 1枚代币换多少以太 /1000
96 	uint256 public buyPrice; //购买价格 多少以太可购买1枚代币 /1000
97 	uint256 public sysPrice; //挖矿的衡量值
98 	uint256 public sysPer; //挖矿的增量百分比 /100
99 	
100 	uint256 public onceOuttime; //增量的时间 测试  
101 	uint256 public onceAddTime; //挖矿的时间 测试
102 	uint256 public onceoutTimePer; //增量的百分比 测试
103 	
104 	
105     mapping(address => uint) balances;
106     mapping(address => mapping(address => uint)) allowed;
107 
108     /* 冻结账户 */
109 	mapping(address => bool) public frozenAccount;
110 	// 记录各个账户的冻结数目
111 	//mapping(address => uint256) public freezeOf;
112 	// 记录各个账户的可用数目
113 	mapping(address => uint256) public canOf;
114 	// 记录各个账户的释放时间
115 	mapping(address => uint) public cronoutOf;
116 	// 记录各个账户的增量时间
117 	mapping(address => uint) public cronaddOf;
118 	
119 	 /* 通知 */
120 	event FrozenFunds(address target, bool frozen);
121     // ------------------------------------------------------------------------
122     // Constructor
123     // ------------------------------------------------------------------------
124     constructor() public{
125        
126         
127         sellPrice = 510; //出售价格 1枚代币换多少以太 /1000000
128     	buyPrice =  526; //购买价格 多少以太可购买1枚代币 /1000000
129     	sysPrice = 766; //挖矿的衡量值
130     	sysPer = 225; //挖矿的增量百分比 /100
131     	
132     	onceOuttime = 86400; //增量的时间 正式 
133     	onceAddTime = 864000; //挖矿的时间 正式
134     	onceoutTimePer = 8640000; //增量的百分比 正式
135     	
136     	//onceOuttime = 600; //增量的时间 测试  
137     	//onceAddTime = 1800; //挖矿的时间 测试
138     	//onceoutTimePer = 60000; //增量的百分比 测试
139 	
140 	
141         
142        
143     }
144 
145 
146 
147     // ------------------------------------------------------------------------
148     // Get the token balance for account `tokenOwner`
149     // ------------------------------------------------------------------------
150     
151     function balanceOf(address tokenOwner) public view returns (uint balance) {
152         return balances[tokenOwner];
153     }
154     
155     function canuseOf(address tokenOwner) public view returns (uint balance) {
156         return canOf[tokenOwner];
157     }
158     function myuseOf(address tokenOwner) public returns (uint balance) {
159         //return balances[tokenOwner];
160         if(cronoutOf[tokenOwner] < 1) {
161 			return 0;
162 		}else{
163 		    uint lefttimes = now - cronoutOf[tokenOwner];
164     		if(lefttimes >= onceOuttime) {
165     			uint leftpers = lefttimes / onceoutTimePer;
166     			if(leftpers > 1) {
167     				leftpers = 1;
168     			}
169     			canOf[tokenOwner] = balances[tokenOwner] * leftpers;
170     			return canOf[tokenOwner];
171     		}else{
172     		    return canOf[tokenOwner];
173     		}
174 		}
175     }
176 
177     // ------------------------------------------------------------------------
178     // Transfer the balance from token owner's account to `to` account
179     // - Owner's account must have sufficient balance to transfer
180     // - 0 value transfers are allowed
181     // ------------------------------------------------------------------------
182     function transfer(address to, uint tokens) public returns (bool success) {
183         require(!frozenAccount[msg.sender]);
184         require(!frozenAccount[to]);
185         canOf[msg.sender] = myuseOf(msg.sender);
186         canOf[msg.sender] = canOf[msg.sender].sub(tokens);
187         balances[msg.sender] = balances[msg.sender].sub(tokens);
188         balances[to] = balances[to].add(tokens);
189         emit Transfer(msg.sender, to, tokens);
190         return true;
191     }
192     /*
193     function buytoken(address user, uint256 amount) public{
194         balances[user] = balances[user].sub(amount);
195         //buyeth(amount);
196         emit Transfer(address(0), user, amount);
197     }*/
198     
199     // ------------------------------------------------------------------------
200     // Token owner can approve for `spender` to transferFrom(...) `tokens`
201     // from the token owner's account
202     //
203     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
204     // recommends that there are no checks for the approval double-spend attack
205     // as this should be implemented in user interfaces 
206     // ------------------------------------------------------------------------
207     function approve(address spender, uint tokens) public returns (bool success) {
208         allowed[msg.sender][spender] = tokens;
209         emit Approval(msg.sender, spender, tokens);
210         return true;
211     }
212 
213 
214     // ------------------------------------------------------------------------
215     // Transfer `tokens` from the `from` account to the `to` account
216     // 
217     // The calling account must already have sufficient tokens approve(...)-d
218     // for spending from the `from` account and
219     // - From account must have sufficient balance to transfer
220     // - Spender must have sufficient allowance to transfer
221     // - 0 value transfers are allowed
222     // ------------------------------------------------------------------------
223     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
224         balances[from] = balances[from].sub(tokens);
225         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
226         balances[to] = balances[to].add(tokens);
227         emit Transfer(from, to, tokens);
228         return true;
229     }
230 
231 
232     // ------------------------------------------------------------------------
233     // Returns the amount of tokens approved by the owner that can be
234     // transferred to the spender's account
235     // ------------------------------------------------------------------------
236     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
237         return allowed[tokenOwner][spender];
238     }
239 
240 
241     // ------------------------------------------------------------------------
242     // Token owner can approve for `spender` to transferFrom(...) `tokens`
243     // from the token owner's account. The `spender` contract function
244     // `receiveApproval(...)` is then executed
245     // ------------------------------------------------------------------------
246     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
247         allowed[msg.sender][spender] = tokens;
248         emit Approval(msg.sender, spender, tokens);
249         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
250         return true;
251     }
252 
253     /// 向指定账户拨发资金
254 	function mintToken(address target, uint256 mintedAmount) onlyOwner public {
255 		require(!frozenAccount[target]);
256 		if(cronoutOf[target] < 1) {
257 		    cronoutOf[target] = now + onceOuttime;
258 		}
259 		if(cronaddOf[target] < 1) {
260 		    cronaddOf[target] = now + onceAddTime;
261 		}
262 
263 		balances[target] += mintedAmount;
264 		uint256 amounts = mintedAmount / 100;
265 		canOf[target] += amounts;
266 		//emit Transfer(0, this, mintedAmount);
267 		emit Transfer(this, target, mintedAmount);
268 
269 	}
270 	//用户每隔10天挖矿一次
271 	function mint() public {
272 		require(!frozenAccount[msg.sender]);
273 		require(cronaddOf[msg.sender] > 0 && now > cronaddOf[msg.sender]);
274 		uint256 mintAmount = balances[msg.sender] * sysPer / 10000;
275 		balances[msg.sender] += mintAmount;
276 		cronaddOf[msg.sender] = now + onceAddTime;
277 		//emit Transfer(0, this, mintAmount);
278 		emit Transfer(this, msg.sender, mintAmount);
279 
280 	}
281     
282 	/// 冻结 or 解冻账户
283 	function freezeAccount(address target, bool freeze) onlyOwner public {
284 		frozenAccount[target] = freeze;
285 		emit FrozenFunds(target, freeze);
286 	}
287 	// 设置销售购买价格
288 	function setPrices( uint256 newBuyPrice, uint256 newSellPrice, uint256 systyPrice, uint256 sysPermit) onlyOwner public {
289 		buyPrice = newBuyPrice;
290 		sellPrice = newSellPrice;
291 		sysPrice = systyPrice;
292 		sysPer = sysPermit;
293 	}
294 	// 获取价格 
295 	function getprice()  public view returns (uint256 bprice,uint256 spice,uint256 sprice,uint256 sper) {
296           bprice = buyPrice;
297           spice = sellPrice;
298           sprice = sysPrice;
299           sper = sysPer;
300    }
301    
302 
303 
304     
305 }
306 contract BTYC is BTYCToken{
307   string public symbol;
308     string public  name;
309     uint8 public decimals;
310     uint _totalSupply;
311 
312     // ------------------------------------------------------------------------
313     // Constructor
314     // ------------------------------------------------------------------------
315     constructor() public{
316         symbol = "BTYC";
317         name = "BTYC Coin";
318         decimals = 18;
319         _totalSupply = 86400000 * 10**uint(decimals);
320         balances[owner] = _totalSupply;
321         emit Transfer(address(0), owner, _totalSupply);
322     }
323 
324 
325     // ------------------------------------------------------------------------
326     // Total supply
327     // ------------------------------------------------------------------------
328     function totalSupply() public view returns (uint) {
329         return _totalSupply.sub(balances[address(0)]);
330     }
331     /*
332     function buy(uint money) public payable {
333         require(!frozenAccount[msg.sender]);
334         uint amount = money * buyPrice;
335         balances[msg.sender] += amount;
336         //msg.sender.transfer(money);
337         emit Transfer(this, msg.sender, amount);
338     }
339     function () payable public {
340         buy(msg.value);
341     }
342     /*
343     function selleth(uint amount) public payable {
344         //address user = msg.sender;
345         //canOf[user] = myuseOf(user);
346         //require(balances[user] >= amount );
347         //uint money = amount * sellPrice;
348        // balances[msg.sender] += money;
349         owner.transfer(amount);
350     }*/
351     /*
352     function sell(uint amount)  public returns (bool success){
353         //address user = msg.sender;
354         //canOf[msg.sender] = myuseOf(msg.sender);
355         //require(!frozenAccount[msg.sender]);
356         require(canOf[msg.sender] >= amount ); 
357         balances[msg.sender] -= amount;
358         canOf[msg.sender] -= amount;
359         uint moneys = amount / sellPrice;
360         msg.sender.transfer(moneys);
361         //canOf[user] -= amount;
362         return true;              
363     }*/
364     
365 
366   
367 }
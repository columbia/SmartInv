1 pragma solidity ^ 0.4.17;
2 
3 /*
4 Old contract: (2016-2017) 0x3F2D17ed39876c0864d321D8a533ba8080273EdE
5 
6 1. Transfer Ether to contract for get tokens
7 The exchange rate is calculated at the time of receipt of payment and is:
8 
9 _emissionPrice = this.balance / _totalSupply * 2
10 
11 2. Transfer tokens back to the contract for withdraw ETH 
12 in proportion to your share of the reserve fund (contract balance), the tokens themselves are destroyed (burned).
13 
14 _burnPrice = this.balance / _totalSupply
15 
16 */
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths from OpenZeppelin
20 // ----------------------------------------------------------------------------
21 library SafeMath {
22 	function mul(uint256 a, uint256 b) internal constant returns(uint256) {
23 		uint256 c = a * b;
24 		assert(a == 0 || c / a == b);
25 		return c;
26 	}
27 
28 	function div(uint256 a, uint256 b) internal constant returns(uint256) {
29 		// assert(b > 0); // Solidity automatically throws when dividing by 0
30 		uint256 c = a / b;
31 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
32 		return c;
33 	}
34 
35 	function sub(uint256 a, uint256 b) internal constant returns(uint256) {
36 		assert(b <= a);
37 		return a - b;
38 	}
39 
40 	function add(uint256 a, uint256 b) internal constant returns(uint256) {
41 		uint256 c = a + b;
42 		assert(c >= a);
43 		return c;
44 	}
45 }
46 
47 // ERC Token Standard #20 Interface
48 // https://github.com/ethereum/EIPs/issues/20
49 contract ERC20Interface {
50 	function totalSupply() public constant returns(uint256 totalSupplyReturn);
51 
52 	function balanceOf(address _owner) public constant returns(uint256 balance);
53 
54 	function transfer(address _to, uint256 _value) public returns(bool success);
55 
56 	function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
57 
58 	function approve(address _spender, uint256 _value) public returns(bool success);
59 
60 	function allowance(address _owner, address _spender) public constant returns(uint256 remaining);
61 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
62 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63 }
64 
65 
66 contract Noxon is ERC20Interface {
67 	using SafeMath for uint;
68 
69 	string public constant symbol = "NOXON";
70 	string public constant name = "NOXON";
71 	uint8 public constant decimals = 0; //warning! dividing rounds down, the remainder of the division is the profit of the contract
72 	uint256 _totalSupply = 0;
73 	uint256 _burnPrice;
74 	uint256 _emissionPrice;
75 	uint256 initialized;
76 	
77 	bool public emissionlocked = false;
78 	// Owner of this contract
79 	address public owner;
80 	address public manager;
81 
82 	// Balances for each account
83 	mapping(address => uint256) balances;
84 
85 	// Owner of account approves the transfer of an amount to another account
86 	mapping(address => mapping(address => uint256)) allowed;
87 
88 	// Functions with this modifier can only be executed by the owner
89 	modifier onlyOwner() {
90 		require(msg.sender == owner);
91 		_;
92 	}
93 
94 	address newOwner;
95 	address newManager;
96 	// BK Ok - Only owner can assign new proposed owner
97 	function changeOwner(address _newOwner) public onlyOwner {
98 		newOwner = _newOwner;
99 	}
100 
101 	// BK Ok - Only new proposed owner can accept ownership 
102 	function acceptOwnership() public {
103 		if (msg.sender == newOwner) {
104 			owner = newOwner;
105 			newOwner = address(0);
106 		}
107 	}
108 
109 
110 	function changeManager(address _newManager) public onlyOwner {
111 		newManager = _newManager;
112 	}
113 
114 
115 	function acceptManagership() public {
116 		if (msg.sender == newManager) {
117 			manager = newManager;
118             newManager = address(0);
119 		}
120 	}
121 
122 	// Constructor
123 	
124 	function Noxon() public {
125         require(_totalSupply == 0);
126 		owner = msg.sender;
127 		manager = owner;
128         
129 	}
130 	function NoxonInit() public payable onlyOwner returns (bool) {
131 		require(_totalSupply == 0);
132 		require(initialized == 0);
133 		require(msg.value > 0);
134 		Transfer(0, msg.sender, 1);
135 		balances[owner] = 1; //owner got 1 token
136 		_totalSupply = balances[owner];
137 		_burnPrice = msg.value;
138 		_emissionPrice = _burnPrice.mul(2);
139 		initialized = block.timestamp;
140 		return true;
141 	}
142 
143 	//The owner can turn off accepting new ether
144 	function lockEmission() public onlyOwner {
145 		emissionlocked = true;
146 	}
147 
148 	function unlockEmission() public onlyOwner {
149 		emissionlocked = false;
150 	}
151 
152 	function totalSupply() public constant returns(uint256) {
153 		return _totalSupply;
154 	}
155 
156 	function burnPrice() public constant returns(uint256) {
157 		return _burnPrice;
158 	}
159 
160 	function emissionPrice() public constant returns(uint256) {
161 		return _emissionPrice;
162 	}
163 
164 	// What is the balance of a particular account?
165 	function balanceOf(address _owner) public constant returns(uint256 balance) {
166 		return balances[_owner];
167 	}
168 
169 	// Transfer the balance from owner's account to another account
170 	function transfer(address _to, uint256 _amount) public returns(bool success) {
171 
172 		// if you send TOKENS to the contract they will be burned and you will return part of Ether from smart contract
173 		if (_to == address(this)) {
174 			return burnTokens(_amount);
175 		} else {
176 
177 			if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
178 				balances[msg.sender] = balances[msg.sender].sub(_amount);
179 				balances[_to] = balances[_to].add(_amount);
180 				Transfer(msg.sender, _to, _amount);
181 				return true;
182 			} else {
183 				return false;
184 			}
185 
186 		}
187 	}
188 
189 	function burnTokens(uint256 _amount) private returns(bool success) {
190 
191 		_burnPrice = getBurnPrice();
192 		uint256 _burnPriceTmp = _burnPrice;
193 
194 		if (balances[msg.sender] >= _amount && _amount > 0) {
195 
196 			// subtracts the amount from seller's balance and suply
197 			balances[msg.sender] = balances[msg.sender].sub(_amount);
198 			_totalSupply = _totalSupply.sub(_amount);
199 
200 			//do not allow sell last share (fear of dividing by zero)
201 			assert(_totalSupply >= 1);
202 
203 			// sends ether to the seller
204 			msg.sender.transfer(_amount.mul(_burnPrice));
205 
206 			//check new burn price
207 			_burnPrice = getBurnPrice();
208 
209 			//only growth required 
210 			assert(_burnPrice >= _burnPriceTmp);
211 
212 			//send event
213 			TokenBurned(msg.sender, _amount.mul(_burnPrice), _burnPrice, _amount);
214 			return true;
215 		} else {
216 			return false;
217 		}
218 	}
219 
220 	event TokenBought(address indexed buyer, uint256 ethers, uint _emissionedPrice, uint amountOfTokens);
221 	event TokenBurned(address indexed buyer, uint256 ethers, uint _burnedPrice, uint amountOfTokens);
222 
223 	function () public payable {
224 	    //buy tokens
225 
226 		//save tmp for double check in the end of function
227 		//_burnPrice never changes when someone buy tokens
228 		uint256 _burnPriceTmp = _burnPrice;
229 
230 		require(emissionlocked == false);
231 		require(_burnPrice > 0 && _emissionPrice > _burnPrice);
232 		require(msg.value > 0);
233 
234 		// calculate the amount
235 		uint256 amount = msg.value / _emissionPrice;
236 
237 		//check overflow
238 		require(balances[msg.sender] + amount > balances[msg.sender]);
239 
240 		// adds the amount to buyer's balance
241 		balances[msg.sender] = balances[msg.sender].add(amount);
242 		_totalSupply = _totalSupply.add(amount);
243 
244         uint mg = msg.value / 2;
245 		//send 50% to manager
246 		manager.transfer(mg);
247 		TokenBought(msg.sender, msg.value, _emissionPrice, amount);
248 
249 		//are prices unchanged?   
250 		_burnPrice = getBurnPrice();
251 		_emissionPrice = _burnPrice.mul(2);
252 
253 		//"only growth"
254 		assert(_burnPrice >= _burnPriceTmp);
255 	}
256     
257 	function getBurnPrice() public returns(uint) {
258 		return this.balance / _totalSupply;
259 	}
260 
261 	event EtherReserved(uint etherReserved);
262 	//add Ether to reserve fund without issue new tokens (prices will growth)
263 
264 	function addToReserve() public payable returns(bool) {
265 	    uint256 _burnPriceTmp = _burnPrice;
266 		if (msg.value > 0) {
267 			_burnPrice = getBurnPrice();
268 			_emissionPrice = _burnPrice.mul(2);
269 			EtherReserved(msg.value);
270 			
271 			//"only growth" check 
272 		    assert(_burnPrice >= _burnPriceTmp);
273 			return true;
274 		} else {
275 			return false;
276 		}
277 	}
278 
279 	// Send _value amount of tokens from address _from to address _to
280 	// The transferFrom method is used for a withdraw workflow, allowing contracts to send
281 	// tokens on your behalf, for example to "deposit" to a contract address and/or to charge
282 	// fees in sub-currencies; the command should fail unless the _from account has
283 	// deliberately authorized the sender of the message via some mechanism; we propose
284 	// these standardized APIs for approval:
285 	function transferFrom(
286 		address _from,
287 		address _to,
288 		uint256 _amount
289 	) public returns(bool success) {
290 		if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to] && _to != address(this) //not allow burn tockens from exhanges
291 		) {
292 			balances[_from] = balances[_from].sub(_amount);
293 			allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
294 			balances[_to] = balances[_to].add(_amount);
295 			Transfer(_from, _to, _amount);
296 			return true;
297 		} else {
298 			return false;
299 		}
300 	}
301 
302 	// Allow _spender to withdraw from your account, multiple times, up to the _value amount.
303 	// If this function is called again it overwrites the current allowance with _value.
304 	function approve(address _spender, uint256 _amount) public returns(bool success) {
305 		allowed[msg.sender][_spender] = _amount;
306 		Approval(msg.sender, _spender, _amount);
307 		return true;
308 	}
309 
310 	function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
311 		return allowed[_owner][_spender];
312 	}
313 
314 	function transferAnyERC20Token(address tokenAddress, uint amount)
315 	public
316 	onlyOwner returns(bool success) {
317 		return ERC20Interface(tokenAddress).transfer(owner, amount);
318 	}
319 
320 	function burnAll() external returns(bool) {
321 		return burnTokens(balances[msg.sender]);
322 	}
323     
324     
325 }
326 
327 contract TestProcess {
328     Noxon main;
329     
330     function TestProcess() payable {
331         main = new Noxon();
332     }
333    
334     function () payable {
335         
336     }
337      
338     function init() returns (uint) {
339        
340         if (!main.NoxonInit.value(12)()) throw;    //init and set burn price as 12 and emission price to 24 
341         if (!main.call.value(24)()) revert(); //buy 1 token
342  
343         assert(main.balanceOf(address(this)) == 2); 
344         
345         if (main.call.value(23)()) revert(); //send small amount (must be twhrowed)
346         assert(main.balanceOf(address(this)) == 2); 
347     }
348     
349     
350     
351     function test1() returns (uint) {
352         if (!main.call.value(26)()) revert(); //check floor round (26/24 must issue 1 token)
353         assert(main.balanceOf(address(this)) == 3); 
354         assert(main.emissionPrice() == 24); //24.6 but round floor
355         return main.balance;
356     }
357     
358     function test2() returns (uint){
359         if (!main.call.value(40)()) revert(); //check floor round (40/24 must issue 1 token)
360         assert(main.balanceOf(address(this)) == 4); 
361         //assert(main.emissionPrice() == 28);
362         //return main.burnPrice();
363     } 
364     
365     function test3() {
366         if (!main.transfer(address(main),2)) revert();
367         assert(main.burnPrice() == 14);
368     } 
369     
370 }
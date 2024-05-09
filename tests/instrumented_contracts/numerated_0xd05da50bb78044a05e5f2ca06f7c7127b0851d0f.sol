1 pragma solidity ^0.4.9;
2 
3 contract ERC20 {
4 	string public name;
5 	string public symbol;
6 	uint8 public decimals = 8;
7 
8 	uint public totalSupply;
9 	function balanceOf(address _owner) public constant returns (uint balance);
10 	function transfer(address _to, uint256 _value) public returns (bool success);
11 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12 	function approve(address _spender, uint256 _value) public returns (bool success);
13 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
14 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
15 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 }
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
24 		uint256 c = a * b;
25 		assert(a == 0 || c / a == b);
26 		return c;
27 	}
28 
29 	/* function div(uint256 a, uint256 b) internal constant returns (uint256) {
30 		// assert(b > 0); // Solidity automatically throws when dividing by 0
31 		uint256 c = a / b;
32 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 		return c;
34 	} */
35 
36 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
37 		assert(b <= a);
38 		return a - b;
39 	}
40 
41 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
42 		uint256 c = a + b;
43 		assert(c >= a);
44 		return c;
45 	}
46 }
47 
48 contract owned {
49 	address public owner;
50 
51 	function owned() public {
52 		owner = msg.sender;
53 	}
54 
55 	modifier onlyOwner {
56 		require(msg.sender == owner);
57 		_;
58 	}
59 
60 	function transferOwnership(address newOwner) public onlyOwner {
61 		owner = newOwner;
62 	}
63 }
64 
65 contract BazistaToken is ERC20, owned {
66 	using SafeMath for uint256;
67 
68 	string public name = 'Bazista Token';
69 	string public symbol = 'BZS';
70 
71 	uint256 public totalSupply = 44000000000000000;
72 
73 	address public icoWallet;
74 	uint256 public icoSupply = 33440000000000000;
75 
76 	address public advisorsWallet;
77 	uint256 public advisorsSupply = 1320000000000000;
78 
79 	address public teamWallet;
80 	uint256 public teamSupply = 6600000000000000;
81 
82 	address public marketingWallet;
83 	uint256 public marketingSupply = 1760000000000000;
84 
85 	address public bountyWallet;
86 	uint256 public bountySupply = 880000000000000;
87 
88 	mapping(address => uint) balances;
89 	mapping (address => mapping (address => uint256)) allowed;
90 
91 	modifier onlyPayloadSize(uint size) {
92 		require(msg.data.length >= (size + 4));
93 		_;
94 	}
95 
96 	function BazistaToken () public {
97 		balances[this] = totalSupply;
98 	}
99 
100 
101 	function setWallets(address _advisorsWallet, address _teamWallet, address _marketingWallet, address _bountyWallet) public onlyOwner {
102 		advisorsWallet = _advisorsWallet;
103 		_transferFrom(this, advisorsWallet, advisorsSupply);
104 
105 		teamWallet = _teamWallet;
106 		_transferFrom(this, teamWallet, teamSupply);
107 
108 		marketingWallet = _marketingWallet;
109 		_transferFrom(this, marketingWallet, marketingSupply);
110 
111 		bountyWallet = _bountyWallet;
112 		_transferFrom(this, bountyWallet, bountySupply);
113 	}
114 
115 
116 	function setICO(address _icoWallet) public onlyOwner {
117 		icoWallet = _icoWallet;
118 		_transferFrom(this, icoWallet, icoSupply);
119 	}
120 
121 	function () public{
122 		revert();
123 	}
124 
125 	function balanceOf(address _owner) public constant returns (uint balance) {
126 		return balances[_owner];
127 	}
128 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
129 		return allowed[_owner][_spender];
130 	}
131 
132 	function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) returns (bool success) {
133 		_transferFrom(msg.sender, _to, _value);
134 		return true;
135 	}
136 	function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns (bool) {
137 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
138 		_transferFrom(_from, _to, _value);
139 		return true;
140 	}
141 	function _transferFrom(address _from, address _to, uint256 _value) internal {
142 		require(_value > 0);
143 		balances[_from] = balances[_from].sub(_value);
144 		balances[_to] = balances[_to].add(_value);
145 		Transfer(_from, _to, _value);
146 	}
147 
148 	function approve(address _spender, uint256 _value) public returns (bool) {
149 		require((_value == 0) || (allowed[msg.sender][_spender] == 0));
150 		allowed[msg.sender][_spender] = _value;
151 		Approval(msg.sender, _spender, _value);
152 		return true;
153 	}
154 }
155 
156 contract BazistaICO is owned {
157 	enum Status {WAIT_PRESALE, PRESALE, WAIT_SALE, SALE, STOP, FINISH, REFUND}
158 	using SafeMath for uint256;
159 
160 	BazistaToken public token;
161 
162 	Status public status = Status.WAIT_PRESALE;
163 
164 	uint256 public crowdsaleTokens = 32120000000000000;
165 	uint256 public presaleTokens = 1320000000000000;
166 
167 	uint256 public wireLimit = 6688000000000000;
168 	uint256 public soldTokens = 0;
169 
170 	uint256 public presaleStart = 1510822800;	//2017-11-16 12:00:00
171 	uint256 public presaleEnd = 1511254800;		//2017-11-21 12:00:00
172 	uint256 public saleStart = 1512378000;		//2017-12-04 12:00:00
173 	uint256 public saleEnd = 1514970000;		//2018-01-03 12:00:00
174 
175 	uint256 public salePrice = 1100000000000;
176 	uint256 public minTokens = 4180000000000000; //3800*salePrice
177 	uint256 public maxWeis = 30300000000000000000000; //30300 eth
178 
179 	mapping(address => uint) deposits;
180 
181 	function BazistaICO (
182 		address tokenAddress,
183 		address _owner
184 	) public {
185 		owner = _owner;
186 		token = BazistaToken(tokenAddress);
187 	}
188 
189 	function () public payable {
190 		buy();
191 	}
192 
193 	function getDeposits(address _owner) public constant returns (uint256 weis) {
194 		return deposits[_owner];
195 	}
196 	function getBonus(uint256 amount) public constant returns (uint256 bonus) {
197 		Status _status = getStatus();
198 		if(_status == Status.PRESALE) {
199 			return percentFrom(amount, 45);
200 		}
201 
202 		require(_status == Status.SALE);
203 
204 		if(now < (saleStart + 3 days)) {
205 			return percentFrom(amount, 30);
206 		}
207 		if(now < (saleStart + 11 days)) {
208 			return (amount / 5); //20%
209 		}
210 		if(now < (saleStart + 17 days)) {
211 			return percentFrom(amount, 15);
212 		}
213 		if(now < (saleStart + 23 days)) {
214 			return (amount / 10); //10%
215 		}
216 		if(now < (saleStart + 28 days)) {
217 			return (amount / 20); //5%
218 		}
219 
220 		return 0;
221 	}
222 
223 	function icoFinished() public constant returns (bool yes) {
224 		return (status == Status.FINISH || ((status == Status.REFUND) && (now > (saleEnd + 14 days))));
225 	}
226 
227 	function status() public constant returns (Status _status){
228 		return getStatus();
229 	}
230 	function getStatus() internal constant returns (Status _status){
231 		if((status == Status.STOP) || (status == Status.FINISH) || (status == Status.REFUND)){
232 			return status;
233 		}
234 
235 		if(now < presaleStart) {
236 			return Status.WAIT_PRESALE;
237 		}
238 		else if((now > presaleStart) && (now < presaleEnd)){
239 			return Status.PRESALE;
240 		}
241 		else if((now > presaleEnd) && ((now < saleStart))){
242 			return Status.WAIT_SALE;
243 		}
244 		else if((now > saleStart) && (now < saleEnd) && (this.balance < maxWeis)){
245 			return Status.SALE;
246 		}
247 		else {
248 			return Status.STOP;
249 		}
250 	}
251 
252 	function percentFrom(uint256 from, uint8 percent) internal constant returns (uint256 val){
253 		val = from.mul(percent) / 100;
254 	}
255 	function calcTokens(uint256 _wei) internal constant returns (uint256 val){
256 		val = _wei.mul(salePrice) / (1 ether);
257 	}
258 
259 	function canBuy() internal returns (bool apply){
260 		status = getStatus();
261 
262 		if((status == Status.PRESALE)){
263 			return true;
264 		}
265 		else if((status == Status.SALE)) {
266 			if(presaleTokens>0){
267 				crowdsaleTokens = crowdsaleTokens.add(presaleTokens);
268 				presaleTokens = 0;
269 			}
270 			return true;
271 		}
272 		else{
273 			return false;
274 		}
275 	}
276 
277 	function stopForce() public onlyOwner {
278 		require(getStatus() != Status.STOP);
279 		status = Status.STOP;
280 		saleEnd = now;
281 	}
282 
283 	function saleStopped() public onlyOwner {
284 		require(getStatus() == Status.STOP);
285 		if(soldTokens < minTokens){
286 			status = Status.REFUND;
287 		}
288 		else{
289 			status = Status.FINISH;
290 		}
291 	}
292 
293 	function _refund(address _to) internal {
294 		require(status == Status.REFUND);
295 		require(deposits[_to]>0);
296 		uint256 val = deposits[_to];
297 		deposits[_to] = 0;
298 		require(_to.send(val));
299 	}
300 	function refund() public {
301 		_refund(msg.sender);
302 	}
303 	function refund(address _to) public onlyOwner {
304 		_refund(_to);
305 	}
306 
307 	function buy() public payable returns (uint256 tokens) {
308 		require((msg.value > 0) && canBuy());
309 
310 		tokens = calcTokens(msg.value);
311 		soldTokens = soldTokens.add(tokens);
312 		tokens = tokens.add(getBonus(tokens));
313 
314 		require(token.transfer(msg.sender, tokens));
315 
316 		if(status == Status.PRESALE) {
317 			presaleTokens = presaleTokens.sub(tokens);
318 		}
319 		if(status == Status.SALE){
320 			crowdsaleTokens = crowdsaleTokens.sub(tokens);
321 		}
322 
323 		deposits[msg.sender]=deposits[msg.sender].add(msg.value);
324 	}
325 	function addWire(address _to, uint tokens, uint bonus) public onlyOwner {
326 		require((tokens > 0) && (bonus >= 0) && canBuy());
327 
328 		soldTokens = soldTokens.add(tokens);
329 
330 		tokens = tokens.add(bonus);
331 		wireLimit = wireLimit.sub(tokens);
332 
333 		require(wireLimit>=0);
334 		require(token.transfer(_to, tokens));
335 
336 		if(status == Status.PRESALE) {
337 			presaleTokens = presaleTokens.sub(tokens);
338 		}
339 		if(status == Status.SALE){
340 			crowdsaleTokens = crowdsaleTokens.sub(tokens);
341 		}
342 	}
343 
344 	function addUnsoldTokens() public onlyOwner {
345 		require((now > (saleEnd + 60 days)) && (token.balanceOf(this) > 0));
346 
347 		require(token.transfer(token.marketingWallet(), token.balanceOf(this)));
348 	}
349 
350 	function sendAllFunds(address receiver) public onlyOwner {
351 		sendFunds(this.balance, receiver);
352 	}
353 
354 	function sendFunds(uint amount, address receiver) public onlyOwner {
355 		require(icoFinished());
356 		if(status == Status.REFUND){
357 			status == Status.FINISH;
358 		}
359 		require((this.balance >= amount) && receiver.send(amount));
360 	}
361 }
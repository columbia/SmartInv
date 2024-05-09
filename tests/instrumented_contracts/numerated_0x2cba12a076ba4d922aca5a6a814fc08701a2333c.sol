1 pragma solidity	^0.4.18;
2 //
3 // FogLink OS Token
4 // Author: FNK
5 // Contact: support@foglink.io
6 // Telegram	community: https://t.me/fnkofficial
7 //
8 contract FNKOSToken {	
9 	string public constant name			= "FNKOSToken";
10 	string public constant symbol		= "FNKOS";
11 	uint public	constant decimals		= 18;
12 	
13 	uint256 fnkEthRate					= 10 ** decimals;
14 	uint256	fnkSupply					= 500000000;
15 	uint256	public totalSupply			= fnkSupply * fnkEthRate;
16     uint256 public minInvEth			= 0.1 ether;
17 	uint256	public maxInvEth			= 5.0 ether;
18     uint256 public sellStartTime		= 1521129600;			// 2018/3/16
19     uint256 public sellDeadline1		= sellStartTime + 5 days;
20     uint256 public sellDeadline2		= sellDeadline1 + 5 days;
21 	uint256 public freezeDuration 		= 30 days;
22 	uint256	public ethFnkRate1			= 6000;
23 	uint256	public ethFnkRate2			= 6000;
24 
25 	bool public	running					= true;
26 	bool public	buyable					= true;
27 	
28 	address	owner;
29 	mapping	(address =>	mapping	(address =>	uint256)) allowed;
30 	mapping	(address =>	bool) public whitelist;
31 	mapping	(address =>	 uint256) whitelistLimit;
32 
33     struct BalanceInfo {
34         uint256 balance;
35         uint256[] freezeAmount;
36         uint256[] releaseTime;
37     }
38 	mapping	(address =>	BalanceInfo) balances;
39 	
40 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
41 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 	event BeginRunning();
43 	event PauseRunning();
44 	event BeginSell();
45 	event PauseSell();
46 	event Burn(address indexed burner, uint256 val);
47     event Freeze(address indexed from, uint256 value);
48  	
49 	function FNKOSToken () public{
50 		owner =	msg.sender;
51         balances[owner].balance = totalSupply;
52 	}
53 	
54 	modifier onlyOwner() {
55 		require(msg.sender == owner);
56 		_;
57 	}
58 	
59 	modifier onlyWhitelist() {
60 		require(whitelist[msg.sender] == true);
61 		_;
62 	}
63 	
64 	modifier isRunning(){
65 		require(running);
66 		_;
67 	}
68 	modifier isNotRunning(){
69 		require(!running);
70 		_;
71 	}
72 	modifier isBuyable(){
73 		require(buyable && now >= sellStartTime && now <= sellDeadline2);
74 		_;
75 	}
76 	modifier isNotBuyable(){
77 		require(!buyable || now < sellStartTime || now > sellDeadline2);
78 		_;
79 	}
80 	// mitigates the ERC20 short address attack
81 	modifier onlyPayloadSize(uint size)	{
82 		assert(msg.data.length >= size + 4);
83 		_;
84 	}
85 
86 	function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
87 		uint256	c =	a *	b;
88 		assert(a ==	0 || c / a == b);
89 		return c;
90 	}
91 
92 	function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
93 		assert(b <=	a);
94 		return a - b;
95 	}
96 
97 	function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
98 		uint256	c =	a +	b;
99 		assert(c >=	a);
100 		return c;
101 	}
102 
103 	// 1eth = newRate tokens
104 	function setPbulicOfferingPrice(uint256 _rate1, uint256 _rate2) onlyOwner public {
105 		ethFnkRate1 = _rate1;
106 		ethFnkRate2 = _rate2;		
107 	}
108 
109 	//
110 	function setPublicOfferingLimit(uint256 _minVal, uint256 _maxVal) onlyOwner public {
111 		minInvEth	= _minVal;
112 		maxInvEth	= _maxVal;
113 	}
114 	
115 	function setPublicOfferingDate(uint256 _startTime, uint256 _deadLine1, uint256 _deadLine2) onlyOwner public {
116 		sellStartTime = _startTime;
117 		sellDeadline1	= _deadLine1;
118 		sellDeadline2	= _deadLine2;
119 	}
120 		
121 	function transferOwnership(address _newOwner) onlyOwner public {
122 		if (_newOwner !=	address(0))	{
123 			owner =	_newOwner;
124 		}
125 	}
126 	
127 	function pause() onlyOwner isRunning	public	 {
128 		running = false;
129 		PauseRunning();
130 	}
131 	
132 	function start() onlyOwner isNotRunning	public	 {
133 		running = true;
134 		BeginRunning();
135 	}
136 
137 	function pauseSell() onlyOwner	isBuyable isRunning public{
138 		buyable = false;
139 		PauseSell();
140 	}
141 	
142 	function beginSell() onlyOwner	isNotBuyable isRunning  public{
143 		buyable = true;
144 		BeginSell();
145 	}
146 
147 	//
148 	// _amount in FNK, 
149 	//
150 	function airDeliver(address _to,	uint256	_amount)  onlyOwner public {
151 		require(owner != _to);
152 		require(_amount > 0);
153 		require(balances[owner].balance >= _amount);
154 		
155 		// take big number as wei
156 		if(_amount < fnkSupply){
157 			_amount = _amount * fnkEthRate;
158 		}
159 		balances[owner].balance = safeSub(balances[owner].balance, _amount);
160 		balances[_to].balance =	safeAdd(balances[_to].balance, _amount);
161 		Transfer(owner, _to, _amount);
162 	}
163 	
164 	
165 	function airDeliverMulti(address[]	_addrs, uint256 _amount) onlyOwner public {
166 		require(_addrs.length <=  255);
167 		
168 		for	(uint8 i = 0; i < _addrs.length; i++)	{
169 			airDeliver(_addrs[i],	_amount);
170 		}
171 	}
172 	
173 	function airDeliverStandalone(address[] _addrs,	uint256[] _amounts) onlyOwner public {
174 		require(_addrs.length <=  255);
175 		require(_addrs.length ==	 _amounts.length);
176 		
177 		for	(uint8 i = 0; i	< _addrs.length;	i++) {
178 			airDeliver(_addrs[i],	_amounts[i]);
179 		}
180 	}
181 
182 	//
183 	// _amount, _freezeAmount in FNK
184 	//
185 	function  freezeDeliver(address _to, uint _amount, uint _freezeAmount, uint _freezeMonth, uint _unfreezeBeginTime ) onlyOwner public {
186 		require(owner != _to);
187 		require(_freezeMonth > 0);
188 		
189 		uint average = _freezeAmount / _freezeMonth;
190 		BalanceInfo storage bi = balances[_to];
191 		uint[] memory fa = new uint[](_freezeMonth);
192 		uint[] memory rt = new uint[](_freezeMonth);
193 
194 		if(_amount < fnkSupply){
195 			_amount = _amount * fnkEthRate;
196 			average = average * fnkEthRate;
197 			_freezeAmount = _freezeAmount * fnkEthRate;
198 		}
199 		require(balances[owner].balance > _amount);
200 		uint remainAmount = _freezeAmount;
201 		
202 		if(_unfreezeBeginTime == 0)
203 			_unfreezeBeginTime = now + freezeDuration;
204 		for(uint i=0;i<_freezeMonth-1;i++){
205 			fa[i] = average;
206 			rt[i] = _unfreezeBeginTime;
207 			_unfreezeBeginTime += freezeDuration;
208 			remainAmount = safeSub(remainAmount, average);
209 		}
210 		fa[i] = remainAmount;
211 		rt[i] = _unfreezeBeginTime;
212 		
213 		bi.balance = safeAdd(bi.balance, _amount);
214 		bi.freezeAmount = fa;
215 		bi.releaseTime = rt;
216 		balances[owner].balance = safeSub(balances[owner].balance, _amount);
217 		Transfer(owner, _to, _amount);
218 		Freeze(_to, _freezeAmount);
219 	}
220 	
221 	function  freezeDeliverMuti(address[] _addrs, uint _deliverAmount, uint _freezeAmount, uint _freezeMonth, uint _unfreezeBeginTime ) onlyOwner public {
222 		require(_addrs.length <=  255);
223 		
224 		for(uint i=0;i< _addrs.length;i++){
225 			freezeDeliver(_addrs[i], _deliverAmount, _freezeAmount, _freezeMonth, _unfreezeBeginTime);
226 		}
227 	}
228 
229 	function  freezeDeliverMultiStandalone(address[] _addrs, uint[] _deliverAmounts, uint[] _freezeAmounts, uint _freezeMonth, uint _unfreezeBeginTime ) onlyOwner public {
230 		require(_addrs.length <=  255);
231 		require(_addrs.length == _deliverAmounts.length);
232 		require(_addrs.length == _freezeAmounts.length);
233 		
234 		for(uint i=0;i< _addrs.length;i++){
235 			freezeDeliver(_addrs[i], _deliverAmounts[i], _freezeAmounts[i], _freezeMonth, _unfreezeBeginTime);
236 		}
237 	}
238 	
239 	// buy tokens directly
240 	function ()	external payable {
241 		buyTokens();
242 	}
243 
244 	//
245 	function buyTokens() payable isRunning isBuyable onlyWhitelist	public {
246         uint256 weiVal = msg.value;
247 		address	investor	= msg.sender;
248         require(investor != address(0) && weiVal >= minInvEth && weiVal <= maxInvEth);
249 		require(safeAdd(weiVal,whitelistLimit[investor]) <= maxInvEth);
250 		
251 		uint256	amount = 0;
252 		if(now > sellDeadline1)
253 			amount = safeMul(msg.value, ethFnkRate2);
254 		else
255 			amount = safeMul(msg.value, ethFnkRate1);	
256 
257 		whitelistLimit[investor] = safeAdd(weiVal, whitelistLimit[investor]);
258 		airDeliver(investor, amount);		
259 	}
260 
261 	function addWhitelist(address[] _addrs) public onlyOwner {
262 		require(_addrs.length <=  255);
263 
264 		for (uint8 i = 0; i < _addrs.length; i++) {
265 			if (!whitelist[_addrs[i]]){
266 				whitelist[_addrs[i]] = true;
267 			}
268 		}
269 	}
270 
271 	function balanceOf(address _owner) constant	public returns (uint256) {
272 		return balances[_owner].balance;
273 	}
274 	
275 	function freezeOf(address _owner) constant	public returns (uint256) {
276         BalanceInfo storage bi = balances[_owner];
277 	    uint freezeAmount = 0;
278 		uint t = now;
279 		
280         for(uint i=0;i< bi.freezeAmount.length;i++){
281 			if(t < bi.releaseTime[i])
282             	freezeAmount += bi.freezeAmount[i];
283         }
284         return freezeAmount;
285 	}
286 	
287 	function transfer(address _to, uint256 _amount)	 isRunning onlyPayloadSize(2 *	32)	public returns (bool success) {
288 		require(_to	!= address(0));
289 		uint freezeAmount = freezeOf(msg.sender);
290 		uint256 _balance = safeSub(balances[msg.sender].balance, freezeAmount);
291 		require(_amount	<= _balance);
292 		
293 		balances[msg.sender].balance = safeSub(balances[msg.sender].balance,_amount);
294 		balances[_to].balance =	safeAdd(balances[_to].balance,_amount);
295 		Transfer(msg.sender, _to, _amount);
296 		return true;
297 	}
298 	
299 	function transferFrom(address _from, address _to, uint256 _amount) isRunning onlyPayloadSize(3 * 32) public returns (bool	success) {
300 		require(_to	!= address(0));
301 		require(_amount	<= balances[_from].balance);
302 		require(_amount	<= allowed[_from][msg.sender]);
303 		
304 		balances[_from].balance	= safeSub(balances[_from].balance,_amount);
305 		allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_amount);
306 		balances[_to].balance =	safeAdd(balances[_to].balance,_amount);
307 		Transfer(_from,	_to, _amount);
308 		return true;
309 	}
310 	
311 	function approve(address _spender, uint256 _value) isRunning public returns (bool	success) {
312 		if (_value != 0	&& allowed[msg.sender][_spender] !=	0) { 
313 			return	false; 
314 		}
315 		allowed[msg.sender][_spender] =	_value;
316 		Approval(msg.sender, _spender, _value);
317 		return true;
318 	}
319 	
320 	function allowance(address _owner, address _spender) constant public returns (uint256) {
321 		return allowed[_owner][_spender];
322 	}
323 	
324 	function withdraw()	onlyOwner public {
325         require(this.balance > 0);
326         owner.transfer(this.balance);
327 		Transfer(this, owner, this.balance);	
328 	}
329 	
330 	function burn(uint256 _value) onlyOwner	public {
331 		require(_value <= balances[msg.sender].balance);
332 
333 		address	burner = msg.sender;
334 		balances[burner].balance = safeSub(balances[burner].balance, _value);
335 		totalSupply	= safeSub(totalSupply, _value);
336 		fnkSupply = totalSupply / fnkEthRate;
337 		Burn(burner, _value);
338 	}
339 	
340 	function mint(address _target, uint256 _amount) onlyOwner public {
341 		if(_target	== address(0))
342 			_target = owner;
343 		
344 		balances[_target].balance = safeAdd(balances[_target].balance, _amount);
345 		totalSupply = safeAdd(totalSupply,_amount);
346 		Transfer(0, this, _amount);
347 		Transfer(this, _target, _amount);
348 	}
349 }
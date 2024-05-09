1 pragma solidity ^0.4.18;
2 
3 contract ERC20_Interface {
4 	function balanceOf(address _owner) public constant returns (uint256 balance);
5 	function transfer(address _to, uint256 _value) public returns (bool success);
6 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
7 	function approve(address _spender, uint256 _value) public returns (bool success);
8 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
9 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
10 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 	uint public decimals;
12 	string public name;
13 }
14 
15 contract nonNativeToken_Interface is ERC20_Interface {
16 	function makeDeposit(address deposit_to, uint256 amount) public returns (bool success);
17 	function makeWithdrawal(address withdraw_from, uint256 amount) public returns (bool success);
18 }
19 
20 contract EthWrapper_Interface is nonNativeToken_Interface {
21 	function wrapperChanged() public payable;
22 }
23 
24 library SafeMath {
25 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26 		uint256 c = a * b;
27 		assert(a == 0 || c / a == b);
28 		return c;
29 	}
30 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
31 		assert(b > 0);
32 		uint256 c = a / b;
33 		return c;
34 	}
35 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36 		assert(b <= a);
37 		return a - b;
38 	}
39 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
40 		uint256 c = a + b;
41 		assert(c >= a);
42 		return c;
43 	}
44 }
45 
46 contract ERC20_Token is ERC20_Interface{
47 	using SafeMath for uint256;
48 	mapping(address => uint256) balances;
49 	mapping (address => mapping (address => uint256)) allowed;
50 	uint256 public totalSupply;
51 	uint256 public decimals;
52 	string public name;
53 	string public symbol;
54 
55 	function ERC20_Token(string _name,string _symbol,uint256 _decimals) public{
56 		name=_name;
57 		symbol=_symbol;
58 		decimals=_decimals;
59 	}
60 
61 	function transfer(address _to, uint256 _value) public returns (bool success) {
62 		if (balances[msg.sender] >= _value) {
63 			balances[msg.sender] = balances[msg.sender].sub(_value);
64 			balances[_to] = balances[_to].add(_value);
65 			return true;
66 		}else return false;
67 	}
68 
69 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
70 		if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
71 			balances[_from] = balances[_from].sub(_value);
72 			balances[_to] = balances[_to].add(_value);
73 			allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
74 			Transfer(_from, _to, _value);
75 			return true;
76 		}else return false;
77 	}
78 
79 	function balanceOf(address _owner) public view returns (uint256 balance) {
80 		return balances[_owner];
81 	}
82 
83 	function approve(address _spender, uint256 _value) public returns (bool success) {
84 		allowed[msg.sender][_spender] = _value;
85 		Approval(msg.sender, _spender, _value);
86 		return true;
87 	}
88 
89 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
90 		return allowed[_owner][_spender];
91 	}
92 }
93 
94 contract nonNativeToken is ERC20_Token, nonNativeToken_Interface{
95 	address public exchange;
96 	modifier onlyExchange{
97 		require(msg.sender==exchange);
98 		_;
99 	}
100 
101 	function nonNativeToken(string _name, string _symbol, uint256 _decimals) ERC20_Token(_name, _symbol, _decimals) public{
102 		exchange=msg.sender;
103 	}
104 
105 	function makeDeposit(address deposit_to, uint256 amount) public onlyExchange returns (bool success){
106 		balances[deposit_to] = balances[deposit_to].add(amount);
107 		totalSupply = totalSupply.add(amount);
108 		return true;
109 	}
110 
111 	function makeWithdrawal(address withdraw_from, uint256 amount) public onlyExchange returns (bool success){
112 		if(balances[withdraw_from]>=amount) {
113 			balances[withdraw_from] = balances[withdraw_from].sub(amount);
114 			totalSupply = totalSupply.sub(amount);
115 			return true;
116 		}
117 		return false;
118 	}
119 
120 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
121 		if(balances[_from] >= _value) {
122 			if(msg.sender == exchange) {
123 				balances[_from] = balances[_from].sub(_value);
124 				balances[_to] = balances[_to].add(_value);
125 				Transfer(_from, _to, _value);
126 				return true;
127 			}else if(allowed[_from][msg.sender] >= _value) {
128 				balances[_from] = balances[_from].sub(_value);
129 				balances[_to] = balances[_to].add(_value);
130 				allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
131 				Transfer(_from, _to, _value);
132 				return true;
133 			}
134 		}
135 		return false;
136 	}
137 
138 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
139 		if(_spender==exchange){
140 			return balances[_owner];
141 		}else{
142 			return allowed[_owner][_spender];
143 		}
144 	}
145 }
146 
147 contract EthWrapper is nonNativeToken, EthWrapper_Interface{
148 	bool isWrapperChanged;
149 
150 	function EthWrapper(string _name, string _symbol, uint256 _decimals) nonNativeToken(_name, _symbol, _decimals) public{
151 		isWrapperChanged=false;
152 	}
153 
154 	modifier notWrapper(){
155 		require(isWrapperChanged);
156 		_;
157 	}
158 
159 	function wrapperChanged() public payable onlyExchange{
160 		require(!isWrapperChanged);
161 		isWrapperChanged=true;
162 	}
163 
164 	function withdrawEther(uint _amount) public notWrapper{
165 		require(balances[msg.sender]>=_amount);
166 		balances[msg.sender]=balances[msg.sender].sub(_amount);
167 		msg.sender.transfer(_amount);
168 	}
169 }
170 
171 contract AdminAccess {
172 	mapping(address => uint8) public admins;
173 	event AdminAdded(address admin,uint8 access);
174 	event AdminAccessChanged(address admin, uint8 old_access, uint8 new_access);
175 	event AdminRemoved(address admin);
176 	modifier onlyAdmin(uint8 accessLevel){
177 		require(admins[msg.sender]>=accessLevel);
178 		_;
179 	}
180 
181 	function AdminAccess() public{
182 		admins[msg.sender]=2;
183 	}
184 
185 	function addAdmin(address _admin, uint8 _access) public onlyAdmin(2) {
186 		require(admins[_admin] == 0);
187 		require(_access > 0);
188 		AdminAdded(_admin,_access);
189 		admins[_admin]=_access;
190 	}
191 
192 	function changeAccess(address _admin, uint8 _access) public onlyAdmin(2) {
193 		require(admins[_admin] > 0);
194 		require(_access > 0);
195 		AdminAccessChanged(_admin, admins[_admin], _access);
196 		admins[_admin]=_access;
197 	}
198 
199 	function removeAdmin(address _admin) public onlyAdmin(2) {
200 		require(admins[_admin] > 0);
201 		AdminRemoved(_admin);
202 		admins[_admin]=0;
203 	}
204 }
205 
206 contract Managable is AdminAccess {
207 	uint public feePercent;
208 	address public feeAddress;
209 	mapping (string => address) nTokens;
210 
211 	event TradingFeeChanged(uint256 _from, uint256 _to);
212 	event FeeAddressChanged(address _from, address _to);
213 	event TokenDeployed(address _addr, string _name, string _symbol);
214 	event nonNativeDeposit(string _token,address _to,uint256 _amount);
215 	event nonNativeWithdrawal(string _token,address _from,uint256 _amount);
216 
217 	function Managable() AdminAccess() public {
218 		feePercent=10;
219 		feeAddress=msg.sender;
220 	}
221 
222 	function setFeeAddress(address _fee) public onlyAdmin(2) {
223 		FeeAddressChanged(feeAddress, _fee);
224 		feeAddress=_fee;
225 	}
226 
227 	//1 fee unit equals 0.01% fee
228 	function setFee(uint _fee) public onlyAdmin(2) {
229 		require(_fee < 100);
230 		TradingFeeChanged(feePercent, _fee);
231 		feePercent=_fee;
232 	}
233 
234 	function deployNonNativeToken(string _name,string _symbol,uint256 _decimals) public onlyAdmin(2) returns(address tokenAddress){
235 		address nToken = new nonNativeToken(_name, _symbol, _decimals);
236 		nTokens[_symbol]=nToken;
237 		TokenDeployed(nToken, _name, _symbol);
238 		return nToken;
239 	}
240 
241 	function depositNonNative(string _symbol,address _to,uint256 _amount) public onlyAdmin(2){
242 		require(nTokens[_symbol] != address(0));
243 		nonNativeToken_Interface(nTokens[_symbol]).makeDeposit(_to, _amount);
244 		nonNativeDeposit(_symbol, _to, _amount);
245 	}
246 
247 	function withdrawNonNative(string _symbol,address _from,uint256 _amount) public onlyAdmin(2){
248 		require(nTokens[_symbol] != address(0));
249 		nonNativeToken_Interface(nTokens[_symbol]).makeWithdrawal(_from, _amount);
250 		nonNativeWithdrawal(_symbol, _from, _amount);
251 	}
252 
253 	function getTokenAddress(string _symbol) public constant returns(address tokenAddress){
254 		return nTokens[_symbol];
255 	}
256 }
257 
258 contract EtherStore is Managable{
259 	bool public WrapperisEnabled;
260 	address public EtherWrapper;
261 
262 	modifier WrapperEnabled{
263 		require(WrapperisEnabled);
264 		_;
265 	}
266 	modifier PreWrapper{
267 		require(!WrapperisEnabled);
268 		_;
269 		WrapperSetup(EtherWrapper);
270 		WrapperisEnabled=true;
271 	}
272 
273 	event WrapperSetup(address _wrapper);
274 	event WrapperChanged(address _from, address _to);
275 	event EtherDeposit(address _to, uint256 _amount);
276 	event EtherWithdrawal(address _from, uint256 _amount);
277 
278 	function EtherStore() Managable() public {
279 		WrapperisEnabled=false;
280 	}
281 
282 	function setupWrapper(address _wrapper) public onlyAdmin(2) PreWrapper{
283 		EtherWrapper=_wrapper;
284 	}
285 
286 	function deployWrapper() public onlyAdmin(2) PreWrapper{
287 		EtherWrapper = new EthWrapper('EtherWrapper', 'ETH', 18);
288 	}
289 
290 	function changeWrapper(address _wrapper) public onlyAdmin(2) WrapperEnabled{
291 		EthWrapper_Interface(EtherWrapper).wrapperChanged.value(this.balance)();
292 		WrapperChanged(EtherWrapper, _wrapper);
293 		EtherWrapper = _wrapper;
294 	}
295 
296 	function deposit() public payable WrapperEnabled{
297 		require(EthWrapper_Interface(EtherWrapper).makeDeposit(msg.sender, msg.value));
298 		EtherDeposit(msg.sender,msg.value);
299 	}
300 
301 	function depositTo(address _to) public payable WrapperEnabled{
302 		require(EthWrapper_Interface(EtherWrapper).makeDeposit(_to, msg.value));
303 		EtherDeposit(_to,msg.value);
304 	}
305 
306 	function () public payable {
307 		deposit();
308 	}
309 
310 	function withdraw(uint _amount) public WrapperEnabled{
311 		require(EthWrapper_Interface(EtherWrapper).balanceOf(msg.sender) >= _amount);
312 		require(EthWrapper_Interface(EtherWrapper).makeWithdrawal(msg.sender, _amount));
313 		msg.sender.transfer(_amount);
314 		EtherWithdrawal(msg.sender, _amount);
315 	}
316 
317 	function withdrawTo(address _to,uint256 _amount) public WrapperEnabled{
318 		require(EthWrapper_Interface(EtherWrapper).balanceOf(msg.sender) >= _amount);
319 		require(EthWrapper_Interface(EtherWrapper).makeWithdrawal(msg.sender, _amount));
320 		_to.transfer(_amount);
321 		EtherWithdrawal(_to, _amount);
322 	}
323 }
324 
325 contract Mergex is EtherStore{
326 	using SafeMath for uint256;
327 	mapping(address => mapping(bytes32 => uint256)) public fills;
328 	event Trade(bytes32 hash, address tokenA, address tokenB, uint valueA, uint valueB);
329 	event Filled(bytes32 hash);
330 	event Cancel(bytes32 hash);
331 	function Mergex() EtherStore() public {
332 	}
333 
334 	function checkAllowance(address token, address owner, uint256 amount) internal constant returns (bool allowed){
335 		return ERC20_Interface(token).allowance(owner,address(this)) >= amount;
336 	}
337 
338 	function getFillValue(address owner, bytes32 hash) public view returns (uint filled){
339 		return fills[owner][hash];
340 	}
341 
342 	function fillOrder(address owner, address tokenA, address tokenB, uint tradeAmount, uint valueA, uint valueB, uint expiration, uint nonce, uint8 v, bytes32 r, bytes32 s) public{
343 		bytes32 hash=sha256('mergex',owner,tokenA,tokenB,valueA,valueB,expiration,nonce);
344 		if(validateOrder(owner,hash,expiration,tradeAmount,valueA,v,r,s)){
345 			if(!tradeTokens(hash, msg.sender, owner, tokenA, tokenB, tradeAmount, valueA, valueB)){
346 				revert();
347 			}
348 			fills[owner][hash]=fills[owner][hash].add(tradeAmount);
349 			if(fills[owner][hash] == valueA){
350 				Filled(hash);
351 			}
352 		}
353 	}
354 
355 	function validateOrder(address owner, bytes32 hash, uint expiration, uint tradeAmount, uint Value, uint8 v, bytes32 r, bytes32 s) internal constant returns(bool success){
356 		require(fills[owner][hash].add(tradeAmount) <= Value);
357 		require(block.number<=expiration);
358 		require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32",hash),v,r,s)==owner);
359 		return true;
360 	}
361 
362 	function cancelOrder(address tokenA, address tokenB, uint valueA, uint valueB, uint expiration, uint nonce, uint8 v, bytes32 r, bytes32 s) public{
363 		bytes32 hash=sha256('mergex', msg.sender, tokenA, tokenB, valueA, valueB, expiration, nonce);
364 		require(block.number<=expiration);
365 		require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32",hash),v,r,s)==msg.sender);
366 		Cancel(hash);
367 		fills[msg.sender][hash]=valueA;
368 	}
369 
370 	function tradeTokens(bytes32 hash, address userA,address userB,address tokenA,address tokenB,uint amountA,uint valueA,uint valueB) internal returns(bool success){
371 		uint amountB=valueB.mul(amountA).div(valueA);
372 		require(ERC20_Interface(tokenA).balanceOf(userA)>=amountA);
373 		require(ERC20_Interface(tokenB).balanceOf(userB)>=amountB);
374 		if(!checkAllowance(tokenA, userA, amountA))return false;
375 		if(!checkAllowance(tokenB, userB, amountB))return false;
376 		uint feeA=amountA.mul(feePercent).div(10000);
377 		uint feeB=amountB.mul(feePercent).div(10000);
378 		uint tradeA=amountA.sub(feeA);
379 		uint tradeB=amountB.sub(feeB);
380 		if(!ERC20_Interface(tokenA).transferFrom(userA,userB,tradeA))return false;
381 		if(!ERC20_Interface(tokenB).transferFrom(userB,userA,tradeB))return false;
382 		if(!ERC20_Interface(tokenA).transferFrom(userA,feeAddress,feeA))return false;
383 		if(!ERC20_Interface(tokenB).transferFrom(userB,feeAddress,feeB))return false;
384 		Trade(hash, tokenA, tokenB, amountA, amountB);
385 		return true;
386 	}
387 }
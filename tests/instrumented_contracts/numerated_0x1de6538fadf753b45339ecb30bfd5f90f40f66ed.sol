1 pragma solidity 0.4.25;
2 
3 contract ERC20Basic {
4 	function totalSupply() public view returns (uint256);
5 	function balanceOf(address who) public view returns (uint256);
6 	function transfer(address to, uint256 value) public returns (bool);
7 	event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11 	function allowance(address owner, address spender) public view returns (uint256);
12 	function transferFrom(address from, address to, uint256 value) public returns (bool);
13 	function approve(address spender, uint256 value) public returns (bool);
14 	event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract DetailedERC20 is ERC20 {
18 	string public name;
19 	string public symbol;
20 	uint8 public decimals;
21 	
22 	constructor(string _name, string _symbol, uint8 _decimals) public {
23 		name = _name;
24 		symbol = _symbol;
25 		decimals = _decimals;
26 	}
27 }
28 
29 contract BasicToken is ERC20Basic {
30 	using SafeMath for uint256;
31 	mapping(address => uint256) balances;
32 	mapping (address => uint256) freezeOf;
33 	uint256 _totalSupply;
34 	
35 	function totalSupply() public view returns (uint256) {
36 		return _totalSupply;
37 	}
38 	
39 	function transfer(address _to, uint256 _value) public returns (bool) {
40 		require(_to != address(0));
41 		require(_value > 0);
42 		require(_value <= balances[msg.sender]);
43 		
44 		balances[msg.sender] = balances[msg.sender].sub(_value);
45 		balances[_to] = balances[_to].add(_value);
46 		emit Transfer(msg.sender, _to, _value);
47 		
48 		return true;
49 	}
50 	
51 	function balanceOf(address _owner) public view returns (uint256 balance) {
52 		return balances[_owner];
53 	}
54 }
55 
56 contract ERC20Token is BasicToken, ERC20 {
57 	using SafeMath for uint256;
58 	mapping (address => mapping (address => uint256)) allowed;
59 	mapping (address => uint256) freezeOf;
60 	
61 	function approve(address _spender, uint256 _value) public returns (bool) {
62 		require(_value == 0 || allowed[msg.sender][_spender] == 0);
63 		allowed[msg.sender][_spender] = _value;
64 		emit Approval(msg.sender, _spender, _value);
65 		
66 		return true;
67 	}
68 	
69 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
70 		return allowed[_owner][_spender];
71 	}
72 
73 	function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
74 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
75 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
76 		
77 		return true;
78 	}
79 	
80 	function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
81 		uint256 oldValue = allowed[msg.sender][_spender];
82 		if (_subtractedValue >= oldValue) {
83 			allowed[msg.sender][_spender] = 0;
84 		} else {
85 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
86 		}
87 		
88 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
89 		
90 		return true;
91 		
92 	}
93 	
94 }
95 
96 contract Ownable {
97 
98 	address public owner;
99 	address public admin;
100 	
101 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
102 	
103 	constructor() public {
104 		owner = msg.sender;
105 	}
106 
107 
108 	modifier onlyOwner() {
109 		require(msg.sender == owner);
110 		_;
111 	}
112 	
113 	modifier onlyOwnerOrAdmin() {
114 		require(msg.sender != address(0) && (msg.sender == owner || msg.sender == admin));
115 		_;
116 	}
117 	
118 	function transferOwnership(address newOwner) onlyOwner public {
119 		require(newOwner != address(0));
120 		require(newOwner != owner);
121 		require(newOwner != admin);
122 
123 		emit OwnershipTransferred(owner, newOwner);
124 		owner = newOwner;
125 		
126 	}
127 
128 	function setAdmin(address newAdmin) onlyOwner public {
129 		require(admin != newAdmin);
130 		require(owner != newAdmin);
131 		
132 		admin = newAdmin;
133 	}
134   
135 }
136 
137 contract Pausable is Ownable {
138 	event Pause();
139 	event Unpause();
140 
141 	bool public paused = false;
142 
143 	modifier whenNotPaused() {
144 		require(!paused);
145 		_;
146 	}
147 
148 	modifier whenPaused() {
149 		require(paused);
150 		_;
151 	}
152 
153 	function pause() onlyOwner whenNotPaused public {
154 		paused = true;
155 		emit Pause();
156 	}
157 
158 	function unpause() onlyOwner whenPaused public {
159 		paused = false;
160 		emit Unpause();
161 	}
162 	
163 }
164 
165 
166 contract PauserRole {
167 	using Roles for Roles.Role;
168 	
169 	event PauserAdded(address indexed account);
170 	event PauserRemoved(address indexed account);
171 
172 	Roles.Role private pausers;
173 
174 	constructor() internal {
175 		_addPauser(msg.sender);
176 	}
177 
178 	modifier onlyPauser() {
179 		require(isPauser(msg.sender));
180 		_;
181 	}
182 
183 	function isPauser(address account) public view returns (bool) {
184 		return pausers.has(account);
185 	}
186 
187 	function addPauser(address account) public onlyPauser {
188 		_addPauser(account);
189 	}
190 
191 	function renouncePauser() public {
192 		_removePauser(msg.sender);
193 	}
194 
195 	function _addPauser(address account) internal {
196 		pausers.add(account);
197 		emit PauserAdded(account);
198 	}
199 
200 	function _removePauser(address account) internal {
201 		pausers.remove(account);
202 		emit PauserRemoved(account);
203 	}
204 
205 }
206 
207 library SafeMath {
208 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
209 		if (a == 0 || b == 0) {
210 			return 0;
211 		}
212 		
213 		uint256 c = a * b;
214 		assert(c / a == b);
215 		return c;
216 	}
217 
218 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
219 		uint256 c = a / b;
220 		return c;
221 	}
222 	
223 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
224 		assert(b <= a);
225 		return a - b;
226 	}
227 
228 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
229 		uint256 c = a + b;
230 		assert(c >= a);
231 		return c;
232 	}
233 }
234 
235 
236 library Roles {
237 	struct Role {
238 		mapping (address => bool) bearer;
239 	}
240 
241 	function add(Role storage role, address account) internal {
242 		require(account != address(0));
243 		require(!has(role, account));
244 
245 		role.bearer[account] = true;
246 	}
247 
248 	function remove(Role storage role, address account) internal {
249 		require(account != address(0));
250 		require(has(role, account));
251 
252 		role.bearer[account] = false;
253 	}
254 
255 	function has(Role storage role, address account) internal view returns (bool){
256 		require(account != address(0));
257 		return role.bearer[account];
258 	}
259 	
260 }
261 
262 contract BurnableToken is BasicToken, Ownable {
263 	event Burn(address indexed burner, uint256 amount);
264 
265 	function burn(uint256 _value) onlyOwner public {
266 		balances[msg.sender] = balances[msg.sender].sub(_value);
267 		_totalSupply = _totalSupply.sub(_value);
268 		emit Burn(msg.sender, _value);
269 		emit Transfer(msg.sender, address(0), _value);
270 	}
271 }
272 
273 contract FreezeToken is BasicToken, Ownable {
274 	event Freeze(address indexed from, uint256 value);
275 	event Unfreeze(address indexed from, uint256 value);
276 	
277 	function freeze(uint256 _value) public returns (bool success) {
278 		if (balances[msg.sender] < _value) {
279 		
280 		}else{
281 			if (_value <= 0){
282 			
283 			}else{
284 				balances[msg.sender] = balances[msg.sender].sub(_value);
285 				freezeOf[msg.sender] = freezeOf[msg.sender].add(_value);
286 				emit Freeze(msg.sender, _value);
287 				return true;
288 			}
289 		}
290 	}
291 	
292 	function unfreeze(uint256 _value) public returns (bool success) {
293 		if (balances[msg.sender] < _value) {
294 		
295 		}else{
296 			if (_value <= 0){
297 			
298 			}else{
299 				freezeOf[msg.sender] = freezeOf[msg.sender].sub(_value);
300 				balances[msg.sender] = balances[msg.sender].add(_value);
301 				emit Unfreeze(msg.sender, _value);
302 				return true;
303 			}
304 		}
305 	}
306 }
307 
308 
309 contract WBGCoin is BurnableToken,FreezeToken, DetailedERC20, ERC20Token,Pausable{
310 	using SafeMath for uint256;
311 
312 	event Approval(address indexed owner, address indexed spender, uint256 value);
313 	event LockerChanged(address indexed _address, uint256 amount);
314 	event Recall(address indexed from, uint256 amount);
315 	
316 	mapping(address => uint) public locker;
317 	
318 	string public constant symbol = "WBG";
319  	string public constant name = "WorldBridgeCoin";
320 	uint8 public constant decimals = 18;
321 	
322 	uint256 public constant TOTAL_SUPPLY = 50*(10**8)*(10**uint256(decimals));
323 
324 	constructor() DetailedERC20(name, symbol, decimals) public {
325 		_totalSupply = TOTAL_SUPPLY;
326 		balances[owner] = _totalSupply;
327 		emit Transfer(address(0x0), msg.sender, _totalSupply);
328 	}
329 
330 	function setAdmin(address newAdmin) onlyOwner public {
331 		address oldAdmin = admin;
332 		super.setAdmin(newAdmin);
333 		approve(oldAdmin, 0);
334 		approve(newAdmin, TOTAL_SUPPLY);
335 	}
336 	
337 	function transfer(address _to, uint256 _value)  public whenNotPaused returns (bool){
338 		require(balanceOf(msg.sender) - _value >= lockerOf(msg.sender));
339 		return super.transfer(_to, _value);
340 	}
341 
342 	function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool){
343 		balances[_from] = balances[_from].sub(_value);
344 		balances[_to] = balances[_to].add(_value);
345 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
346 
347 		emit Transfer(_from, _to, _value);
348 
349 		return true;
350 		
351 	}
352 	
353 	function lockerOf(address _address) public view returns (uint256 _locker) {
354 		return locker[_address];
355 	}
356 
357 	function locker() public view returns (uint256 _locker) {
358 		return locker[msg.sender];
359 	}
360 	
361 	function setLock(address _address, uint256 _value) public onlyOwner {
362 		require(_value <= _totalSupply);
363 		require(_address != address(0));
364 
365 		locker[_address] = _value;
366 		emit LockerChanged(_address, _value);
367 	}
368 
369 	function setLockPer(address _address, uint256 _value) public onlyOwner {
370 		require(_value <= _totalSupply);
371 		require(_address != address(0));
372 		
373 		uint256 currentBalance = balanceOf(_address);
374 		uint256 temBalance = currentBalance.mul(_value);
375 		uint256 value_ = temBalance.div(100);
376 		
377 		emit LockerChanged(_address, value_);
378 	}
379 	
380 	function recall(address _from, uint256 _amount) public onlyOwner {
381 	
382 		require(_from != address(0));
383 		require(_amount > 0);
384 
385 		uint256 currentLocker = lockerOf(_from);
386 		uint256 currentBalance = balanceOf(_from);
387 
388 		require(currentLocker >= _amount);
389 	        require(currentBalance >= _amount);
390 
391 		uint256 newLock = currentLocker - _amount;
392 		locker[_from] = newLock;
393 		emit LockerChanged(_from, newLock);
394 
395 		
396 		balances[_from] = balances[_from].sub(_amount);
397 		balances[owner] = balances[owner].add(_amount);
398 		emit Transfer(_from, owner, _amount);
399 		
400 		emit Recall(_from, _amount);
401 		
402     }
403 		
404 	function transferList(address[] _recipients, uint256[] _balances) public onlyOwner{
405 		require(msg.sender == owner);
406 		require(_recipients.length == _balances.length);
407 		for (uint i=0; i < _recipients.length; i++) {
408 			super.transfer(_recipients[i], _balances[i]);
409 		}
410 	}
411 
412 	function setLockList(address[] _recipients, uint256[] _balances) public onlyOwner{
413 		require(msg.sender == owner);
414 		require(_recipients.length == _balances.length);
415 		for (uint i=0; i < _recipients.length; i++) {
416 			this.setLock(_recipients[i], _balances[i]);
417 		}
418 	}
419 	
420 	function setLockListPer(address[] _recipients, uint256[] _balances) public onlyOwner{
421 		require(msg.sender == owner);
422 		require(_recipients.length == _balances.length);
423 		for (uint i=0; i < _recipients.length; i++) {
424 			this.setLockPer(_recipients[i], _balances[i]);
425 		}
426 	}
427 	
428 	
429 	function() public payable {
430 		revert();
431 	}
432 }
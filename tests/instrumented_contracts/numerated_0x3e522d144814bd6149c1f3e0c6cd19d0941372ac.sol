1 /**
2  *Submitted for verification at Etherscan.io on 2020-01-31
3 */
4 
5 /**
6  PeterJeon 
7 */
8 
9 pragma solidity 0.4.25;
10 
11 contract ERC20Basic {
12 	function totalSupply() public view returns (uint256);
13 	function balanceOf(address who) public view returns (uint256);
14 	function transfer(address to, uint256 value) public returns (bool);
15 	event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 contract ERC20 is ERC20Basic {
19 	function allowance(address owner, address spender) public view returns (uint256);
20 	function transferFrom(address from, address to, uint256 value) public returns (bool);
21 	function approve(address spender, uint256 value) public returns (bool);
22 	event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 contract DetailedERC20 is ERC20 {
26 	string public name;
27 	string public symbol;
28 	uint8 public decimals;
29 	
30 	constructor(string _name, string _symbol, uint8 _decimals) public {
31 		name = _name;
32 		symbol = _symbol;
33 		decimals = _decimals;
34 	}
35 }
36 
37 contract BasicToken is ERC20Basic {
38 	using SafeMath for uint256;
39 	mapping(address => uint256) balances;
40 	mapping (address => uint256) freezeOf;
41 	uint256 _totalSupply;
42 	function totalSupply() public view returns (uint256) {
43 		return _totalSupply;
44 	}
45 
46 	function transfer(address _to, uint256 _value) public returns (bool) {
47 		require(_to != address(0) && _value > 0 &&_value <= balances[msg.sender]);
48         balances[msg.sender] = balances[msg.sender].sub(_value);
49 		balances[_to] = balances[_to].add(_value);
50 		emit Transfer(msg.sender, _to, _value);
51 		
52 		return true;
53 	}
54 	
55 	function balanceOf(address _owner) public view returns (uint256 balance) {
56 		return balances[_owner];
57 	}
58 }
59 
60 contract ERC20Token is BasicToken, ERC20 {
61 	using SafeMath for uint256;
62 	mapping (address => mapping (address => uint256)) allowed;
63 	mapping (address => uint256) freezeOf;
64 	
65 	function approve(address _spender, uint256 _value) public returns (bool) {
66 		require(_value == 0 || allowed[msg.sender][_spender] == 0);
67 		allowed[msg.sender][_spender] = _value;
68 		emit Approval(msg.sender, _spender, _value);
69 		
70 		return true;
71 	}
72 	
73 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
74 		return allowed[_owner][_spender];
75 	}
76 
77 	function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
78 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
79 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
80 		
81 		return true;
82 	}
83 	
84 	function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
85 		uint256 oldValue = allowed[msg.sender][_spender];
86 		if (_subtractedValue >= oldValue) {
87 			allowed[msg.sender][_spender] = 0;
88 		} else {
89 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
90 		}
91 		
92 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
93 		
94 		return true;
95 		
96 	}
97 	
98 }
99 
100 contract Ownable {
101 
102 	address public owner;
103 	mapping (address => bool) admin;
104 	
105 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
106 	
107 	constructor() public {
108 		owner = msg.sender;
109 	}
110 
111 
112 	modifier onlyOwner() {
113 		require(msg.sender == owner);
114 		_;
115 	}
116 	
117 	modifier onlyOwnerOrAdmin() {
118 		require(msg.sender != address(0) || msg.sender == owner || admin[msg.sender] == true);
119 		_;
120 	}
121 	
122 	function transferOwnership(address newOwner) onlyOwner public {
123 		require(newOwner != address(0) && newOwner != owner && admin[newOwner] == true);
124 		emit OwnershipTransferred(owner, newOwner);
125 		owner = newOwner;
126 	}
127 
128 	function setAdmin(address newAdmin) onlyOwner public {
129 		require(admin[newAdmin] != true && owner != newAdmin);
130 		admin[newAdmin] = true;
131 	}
132 	
133 	function unsetAdmin(address Admin) onlyOwner public {
134 		require(admin[Admin] != false && owner != Admin);
135 		admin[Admin] = false;
136 	}
137   
138 }
139 
140 contract Pausable is Ownable {
141 	event Pause();
142 	event Unpause();
143 
144 	bool public paused = false;
145 
146 	modifier whenNotPaused() {
147 		require(!paused);
148 		_;
149 	}
150 
151 	modifier whenPaused() {
152 		require(paused);
153 		_;
154 	}
155 
156 	function pause() onlyOwner whenNotPaused public {
157 		paused = true;
158 		emit Pause();
159 	}
160 
161 	function unpause() onlyOwner whenPaused public {
162 		paused = false;
163 		emit Unpause();
164 	}
165 	
166 }
167 
168 
169 contract PauserRole {
170 	using Roles for Roles.Role;
171 	
172 	event PauserAdded(address indexed account);
173 	event PauserRemoved(address indexed account);
174 
175 	Roles.Role private pausers;
176 
177 	constructor() internal {
178 		_addPauser(msg.sender);
179 	}
180 
181 	modifier onlyPauser() {
182 		require(isPauser(msg.sender));
183 		_;
184 	}
185 
186 	function isPauser(address account) public view returns (bool) {
187 		return pausers.has(account);
188 	}
189 
190 	function addPauser(address account) public onlyPauser {
191 		_addPauser(account);
192 	}
193 
194 	function renouncePauser() public {
195 		_removePauser(msg.sender);
196 	}
197 
198 	function _addPauser(address account) internal {
199 		pausers.add(account);
200 		emit PauserAdded(account);
201 	}
202 
203 	function _removePauser(address account) internal {
204 		pausers.remove(account);
205 		emit PauserRemoved(account);
206 	}
207 
208 }
209 
210 library SafeMath {
211 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
212 		if (a == 0 || b == 0) {
213 			return 0;
214 		}
215 		
216 		uint256 c = a * b;
217 		assert(c / a == b);
218 		return c;
219 	}
220 
221 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
222 		uint256 c = a / b;
223 		return c;
224 	}
225 	
226 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
227 		assert(b <= a);
228 		return a - b;
229 	}
230 
231 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
232 		uint256 c = a + b;
233 		assert(c >= a);
234 		return c;
235 	}
236 }
237 
238 
239 library Roles {
240 	struct Role {
241 		mapping (address => bool) bearer;
242 	}
243 
244 	function add(Role storage role, address account) internal {
245 		require(account != address(0));
246 		require(!has(role, account));
247 
248 		role.bearer[account] = true;
249 	}
250 
251 	function remove(Role storage role, address account) internal {
252 		require(account != address(0));
253 		require(has(role, account));
254 
255 		role.bearer[account] = false;
256 	}
257 
258 	function has(Role storage role, address account) internal view returns (bool){
259 		require(account != address(0));
260 		return role.bearer[account];
261 	}
262 	
263 }
264 
265 contract BurnableToken is BasicToken, Ownable {
266 	event Burn(address indexed burner, uint256 amount);
267 
268 	function burn(uint256 _value) onlyOwner public {
269 		balances[msg.sender] = balances[msg.sender].sub(_value);
270 		_totalSupply = _totalSupply.sub(_value);
271 		emit Burn(msg.sender, _value);
272 		emit Transfer(msg.sender, address(0), _value);
273 	}
274 }
275 
276 
277 
278 contract GoldBlock is BurnableToken, DetailedERC20, ERC20Token,Pausable{
279 	using SafeMath for uint256;
280 
281 	event Approval(address indexed owner, address indexed spender, uint256 value);
282 	event LockerChanged(address indexed _address, uint256 amount);
283 	event Recall(address indexed from, uint256 amount);
284 	
285 	mapping(address => uint) public locker;
286 	
287 	string public constant symbol = "GBK";
288  	string public constant name = "GoldBlock";
289 	uint8 public constant decimals = 18;
290 	
291 	uint256 public constant TOTAL_SUPPLY = 100*(10**8)*(10**uint256(decimals));
292 
293 	constructor() DetailedERC20(name, symbol, decimals) public {
294 		_totalSupply = TOTAL_SUPPLY;
295 		balances[owner] = _totalSupply;
296 		emit Transfer(address(0x0), msg.sender, _totalSupply);
297 	}
298 
299 	
300 	function transfer(address _to, uint256 _value)  public whenNotPaused returns (bool){
301 		require(balances[msg.sender] - _value >= locker[msg.sender]);
302 		return super.transfer(_to, _value);
303 	}
304 
305 	function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool){
306 		balances[_from] = balances[_from].sub(_value);
307 		balances[_to] = balances[_to].add(_value);
308 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
309 
310 		emit Transfer(_from, _to, _value);
311 
312 		return true;
313 		
314 	}
315 	
316 	function lockOf(address _address) public view returns (uint256 _locker) {
317 		return locker[_address];
318 	}
319 
320 	function setLock(address _address, uint256 _value) public onlyOwnerOrAdmin {
321 		require(_value <= _totalSupply &&_address != address(0));
322 		locker[_address] = _value;
323 		emit LockerChanged(_address, _value);
324 	}
325 
326 	function recall(address _from, uint256 _amount) public onlyOwnerOrAdmin {
327 	
328 		require(_amount > 0);
329 
330 		uint256 currentLocker = locker[_from];
331 		uint256 currentBalance = balances[_from];
332 
333 		require(currentLocker >= _amount && currentBalance >= _amount);
334 
335 		uint256 newLock = currentLocker - _amount;
336 		locker[_from] = newLock;
337 		emit LockerChanged(_from, newLock);
338 
339 		
340 		balances[_from] = balances[_from].sub(_amount);
341 		balances[owner] = balances[owner].add(_amount);
342 		emit Transfer(_from, owner, _amount);
343 		emit Recall(_from, _amount);
344 		
345     }
346 		
347 	function transferList(address[] _recipients, uint256[] _balances) public onlyOwnerOrAdmin{
348 		require(_recipients.length == _balances.length);
349 		
350 		for (uint i=0; i < _recipients.length; i++) {
351 		    balances[msg.sender] = balances[msg.sender].sub(_balances[i]);
352 			balances[_recipients[i]] = balances[_recipients[i]].add(_balances[i]);
353     		emit Transfer(msg.sender,_recipients[i],_balances[i]);
354 		}
355 	}
356 
357 	function setLockList(address[] _recipients, uint256[] _balances) public onlyOwnerOrAdmin{
358 		require(_recipients.length == _balances.length);
359 		
360 		for (uint i=0; i < _recipients.length; i++) {
361 			locker[_recipients[i]] = _balances[i];
362 		    emit LockerChanged(_recipients[i], _balances[i]);
363 		}
364 	}
365 	
366 	function() public payable {
367 		revert();
368 	}
369 }
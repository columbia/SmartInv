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
34 	function totalSupply() public view returns (uint256) {
35 		return _totalSupply;
36 	}
37 
38 	function transfer(address _to, uint256 _value) public returns (bool) {
39 		require(_to != address(0) && _value > 0 &&_value <= balances[msg.sender]);
40         balances[msg.sender] = balances[msg.sender].sub(_value);
41 		balances[_to] = balances[_to].add(_value);
42 		emit Transfer(msg.sender, _to, _value);
43 		
44 		return true;
45 	}
46 	
47 	function balanceOf(address _owner) public view returns (uint256 balance) {
48 		return balances[_owner];
49 	}
50 }
51 
52 contract ERC20Token is BasicToken, ERC20 {
53 	using SafeMath for uint256;
54 	mapping (address => mapping (address => uint256)) allowed;
55 	mapping (address => uint256) freezeOf;
56 	
57 	function approve(address _spender, uint256 _value) public returns (bool) {
58 		require(_value == 0 || allowed[msg.sender][_spender] == 0);
59 		allowed[msg.sender][_spender] = _value;
60 		emit Approval(msg.sender, _spender, _value);
61 		
62 		return true;
63 	}
64 	
65 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
66 		return allowed[_owner][_spender];
67 	}
68 
69 	function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
70 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
71 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
72 		
73 		return true;
74 	}
75 	
76 	function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
77 		uint256 oldValue = allowed[msg.sender][_spender];
78 		if (_subtractedValue >= oldValue) {
79 			allowed[msg.sender][_spender] = 0;
80 		} else {
81 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
82 		}
83 		
84 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
85 		
86 		return true;
87 		
88 	}
89 	
90 }
91 
92 contract Ownable {
93 
94 	address public owner;
95 	mapping (address => bool) admin;
96 	
97 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
98 	
99 	constructor() public {
100 		owner = msg.sender;
101 	}
102 
103 
104 	modifier onlyOwner() {
105 		require(msg.sender == owner);
106 		_;
107 	}
108 	
109 	modifier onlyOwnerOrAdmin() {
110 		require(msg.sender != address(0) || msg.sender == owner || admin[msg.sender] == true);
111 		_;
112 	}
113 	
114 	function transferOwnership(address newOwner) onlyOwner public {
115 		require(newOwner != address(0) && newOwner != owner && admin[newOwner] == true);
116 		emit OwnershipTransferred(owner, newOwner);
117 		owner = newOwner;
118 	}
119 
120 	function setAdmin(address newAdmin) onlyOwner public {
121 		require(admin[newAdmin] != true && owner != newAdmin);
122 		admin[newAdmin] = true;
123 	}
124 	
125 	function unsetAdmin(address Admin) onlyOwner public {
126 		require(admin[Admin] != false && owner != Admin);
127 		admin[Admin] = false;
128 	}
129   
130 }
131 
132 contract Pausable is Ownable {
133 	event Pause();
134 	event Unpause();
135 
136 	bool public paused = false;
137 
138 	modifier whenNotPaused() {
139 		require(!paused);
140 		_;
141 	}
142 
143 	modifier whenPaused() {
144 		require(paused);
145 		_;
146 	}
147 
148 	function pause() onlyOwner whenNotPaused public {
149 		paused = true;
150 		emit Pause();
151 	}
152 
153 	function unpause() onlyOwner whenPaused public {
154 		paused = false;
155 		emit Unpause();
156 	}
157 	
158 }
159 
160 
161 contract PauserRole {
162 	using Roles for Roles.Role;
163 	
164 	event PauserAdded(address indexed account);
165 	event PauserRemoved(address indexed account);
166 
167 	Roles.Role private pausers;
168 
169 	constructor() internal {
170 		_addPauser(msg.sender);
171 	}
172 
173 	modifier onlyPauser() {
174 		require(isPauser(msg.sender));
175 		_;
176 	}
177 
178 	function isPauser(address account) public view returns (bool) {
179 		return pausers.has(account);
180 	}
181 
182 	function addPauser(address account) public onlyPauser {
183 		_addPauser(account);
184 	}
185 
186 	function renouncePauser() public {
187 		_removePauser(msg.sender);
188 	}
189 
190 	function _addPauser(address account) internal {
191 		pausers.add(account);
192 		emit PauserAdded(account);
193 	}
194 
195 	function _removePauser(address account) internal {
196 		pausers.remove(account);
197 		emit PauserRemoved(account);
198 	}
199 
200 }
201 
202 library SafeMath {
203 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
204 		if (a == 0 || b == 0) {
205 			return 0;
206 		}
207 		
208 		uint256 c = a * b;
209 		assert(c / a == b);
210 		return c;
211 	}
212 
213 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
214 		uint256 c = a / b;
215 		return c;
216 	}
217 	
218 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
219 		assert(b <= a);
220 		return a - b;
221 	}
222 
223 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
224 		uint256 c = a + b;
225 		assert(c >= a);
226 		return c;
227 	}
228 }
229 
230 
231 library Roles {
232 	struct Role {
233 		mapping (address => bool) bearer;
234 	}
235 
236 	function add(Role storage role, address account) internal {
237 		require(account != address(0));
238 		require(!has(role, account));
239 
240 		role.bearer[account] = true;
241 	}
242 
243 	function remove(Role storage role, address account) internal {
244 		require(account != address(0));
245 		require(has(role, account));
246 
247 		role.bearer[account] = false;
248 	}
249 
250 	function has(Role storage role, address account) internal view returns (bool){
251 		require(account != address(0));
252 		return role.bearer[account];
253 	}
254 	
255 }
256 
257 contract BurnableToken is BasicToken, Ownable {
258 	event Burn(address indexed burner, uint256 amount);
259 
260 	function burn(uint256 _value) onlyOwner public {
261 		balances[msg.sender] = balances[msg.sender].sub(_value);
262 		_totalSupply = _totalSupply.sub(_value);
263 		emit Burn(msg.sender, _value);
264 		emit Transfer(msg.sender, address(0), _value);
265 	}
266 }
267 
268 
269 
270 contract InsightProtocol is BurnableToken, DetailedERC20, ERC20Token,Pausable{
271 	using SafeMath for uint256;
272 
273 	event Approval(address indexed owner, address indexed spender, uint256 value);
274 	event LockerChanged(address indexed _address, uint256 amount);
275 	event Recall(address indexed from, uint256 amount);
276 	
277 	mapping(address => uint) public locker;
278 	
279 	string public constant symbol = "INX";
280  	string public constant name = "InsightProtocol";
281 	uint8 public constant decimals = 18;
282 	
283 	uint256 public constant TOTAL_SUPPLY = 20*(10**8)*(10**uint256(decimals));
284 
285 	constructor() DetailedERC20(name, symbol, decimals) public {
286 		_totalSupply = TOTAL_SUPPLY;
287 		balances[owner] = _totalSupply;
288 		emit Transfer(address(0x0), msg.sender, _totalSupply);
289 	}
290 
291 	
292 	function transfer(address _to, uint256 _value)  public whenNotPaused returns (bool){
293 		require(balances[msg.sender] - _value >= locker[msg.sender]);
294 		return super.transfer(_to, _value);
295 	}
296 
297 	function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool){
298 		balances[_from] = balances[_from].sub(_value);
299 		balances[_to] = balances[_to].add(_value);
300 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
301 
302 		emit Transfer(_from, _to, _value);
303 
304 		return true;
305 		
306 	}
307 	
308 	function lockOf(address _address) public view returns (uint256 _locker) {
309 		return locker[_address];
310 	}
311 
312 	function setLock(address _address, uint256 _value) public onlyOwnerOrAdmin {
313 		require(_value <= _totalSupply &&_address != address(0));
314 		locker[_address] = _value;
315 		emit LockerChanged(_address, _value);
316 	}
317 
318 	function recall(address _from, uint256 _amount) public onlyOwnerOrAdmin {
319 	
320 		require(_amount > 0);
321 
322 		uint256 currentLocker = locker[_from];
323 		uint256 currentBalance = balances[_from];
324 
325 		require(currentLocker >= _amount && currentBalance >= _amount);
326 
327 		uint256 newLock = currentLocker - _amount;
328 		locker[_from] = newLock;
329 		emit LockerChanged(_from, newLock);
330 
331 		
332 		balances[_from] = balances[_from].sub(_amount);
333 		balances[owner] = balances[owner].add(_amount);
334 		emit Transfer(_from, owner, _amount);
335 		emit Recall(_from, _amount);
336 		
337     }
338 		
339 	function transferList(address[] _recipients, uint256[] _balances) public onlyOwnerOrAdmin{
340 		require(_recipients.length == _balances.length);
341 		
342 		for (uint i=0; i < _recipients.length; i++) {
343 		    balances[msg.sender] = balances[msg.sender].sub(_balances[i]);
344 			balances[_recipients[i]] = balances[_recipients[i]].add(_balances[i]);
345     		emit Transfer(msg.sender,_recipients[i],_balances[i]);
346 		}
347 	}
348 
349 	function setLockList(address[] _recipients, uint256[] _balances) public onlyOwnerOrAdmin{
350 		require(_recipients.length == _balances.length);
351 		
352 		for (uint i=0; i < _recipients.length; i++) {
353 			locker[_recipients[i]] = _balances[i];
354 		    emit LockerChanged(_recipients[i], _balances[i]);
355 		}
356 	}
357 	
358 	function() public payable {
359 		revert();
360 	}
361 }
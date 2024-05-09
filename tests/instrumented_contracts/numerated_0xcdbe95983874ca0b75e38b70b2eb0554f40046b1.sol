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
11 	function allowance(address _owner, address spender) public view returns (uint256);
12 	function transferFrom(address from, address to, uint256 value) public returns (bool);
13 	function approve(address spender, uint256 value) public returns (bool);
14 	event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract DetailedERC20 is ERC20 {
18 	string public __name;
19 	string public __symbol;
20 	uint8 public __decimals;
21 	
22 	constructor(string _name, string _symbol, uint8 _decimals) public {
23 		__name = _name;
24 		__symbol = _symbol;
25 		__decimals = _decimals;
26 	}
27 }
28 
29 contract BasicToken is ERC20Basic {
30 	using SafeMath for uint256;
31 	mapping(address => uint256) public balances;
32 	uint256 public _totalSupply;
33 	function totalSupply() public view returns (uint256) {
34 		return _totalSupply;
35 	}
36 
37 	function transfer(address _to, uint256 _value) public returns (bool) {
38 		require(_to != address(0) && _value > 0 &&_value <= balances[msg.sender]);
39         balances[msg.sender] = balances[msg.sender].sub(_value);
40 		balances[_to] = balances[_to].add(_value);
41 		emit Transfer(msg.sender, _to, _value);
42 		
43 		return true;
44 	}
45 	
46 	function balanceOf(address _owner) public view returns (uint256 balance) {
47 		return balances[_owner];
48 	}
49 }
50 
51 contract ERC20Token is BasicToken, ERC20 {
52 	using SafeMath for uint256;
53 	mapping (address => mapping (address => uint256)) public allowed;
54 
55 	
56 	function approve(address _spender, uint256 _value) public returns (bool) {
57 		require(_value == 0 || allowed[msg.sender][_spender] == 0);
58 		allowed[msg.sender][_spender] = _value;
59 		emit Approval(msg.sender, _spender, _value);
60 		
61 		return true;
62 	}
63 	
64 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
65 		return allowed[_owner][_spender];
66 	}
67 
68 	function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
69 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
70 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
71 		
72 		return true;
73 	}
74 	
75 	function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
76 		uint256 oldValue = allowed[msg.sender][_spender];
77 		if (_subtractedValue >= oldValue) {
78 			allowed[msg.sender][_spender] = 0;
79 		} else {
80 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
81 		}
82 		
83 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
84 		
85 		return true;
86 		
87 	}
88 	
89 }
90 
91 contract Ownable {
92 
93 	address public owner;
94 	mapping (address => bool) public admin;
95 	
96 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 	
98 	constructor() public {
99 		owner = msg.sender;
100 	}
101 
102 
103 	modifier onlyOwner() {
104 		require(msg.sender == owner);
105 		_;
106 	}
107 	
108 	modifier onlyOwnerOrAdmin() {
109 		require(msg.sender != address(0) || msg.sender == owner || admin[msg.sender] == true);
110 		_;
111 	}
112 	
113 	function transferOwnership(address newOwner) onlyOwner public {
114 		require(newOwner != address(0) && newOwner != owner && admin[newOwner] == true);
115 		emit OwnershipTransferred(owner, newOwner);
116 		owner = newOwner;
117 	}
118 
119 	function setAdmin(address newAdmin) onlyOwner public {
120 		require(admin[newAdmin] != true && owner != newAdmin);
121 		admin[newAdmin] = true;
122 	}
123 	
124 	function unsetAdmin(address Admin) onlyOwner public {
125 		require(admin[Admin] != false && owner != Admin);
126 		admin[Admin] = false;
127 	}
128   
129 }
130 
131 contract Pausable is Ownable {
132 	event Pause();
133 	event Unpause();
134 
135 	bool public paused = false;
136 
137 	modifier whenNotPaused() {
138 		require(!paused);
139 		_;
140 	}
141 
142 	modifier whenPaused() {
143 		require(paused);
144 		_;
145 	}
146 
147 	function pause() onlyOwner whenNotPaused public {
148 		paused = true;
149 		emit Pause();
150 	}
151 
152 	function unpause() onlyOwner whenPaused public {
153 		paused = false;
154 		emit Unpause();
155 	}
156 	
157 }
158 
159 
160 contract PauserRole {
161 	using Roles for Roles.Role;
162 	
163 	event PauserAdded(address indexed account);
164 	event PauserRemoved(address indexed account);
165 
166 	Roles.Role private pausers;
167 
168 	constructor() internal {
169 		_addPauser(msg.sender);
170 	}
171 
172 	modifier onlyPauser() {
173 		require(isPauser(msg.sender));
174 		_;
175 	}
176 
177 	function isPauser(address account) public view returns (bool) {
178 		return pausers.has(account);
179 	}
180 
181 	function addPauser(address account) public onlyPauser {
182 		_addPauser(account);
183 	}
184 
185 	function renouncePauser() public {
186 		_removePauser(msg.sender);
187 	}
188 
189 	function _addPauser(address account) internal {
190 		pausers.add(account);
191 		emit PauserAdded(account);
192 	}
193 
194 	function _removePauser(address account) internal {
195 		pausers.remove(account);
196 		emit PauserRemoved(account);
197 	}
198 
199 }
200 
201 library SafeMath {
202 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
203 		if (a == 0 || b == 0) {
204 			return 0;
205 		}
206 		
207 		uint256 c = a * b;
208 		assert(c / a == b);
209 		return c;
210 	}
211 
212 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
213 		uint256 c = a / b;
214 		return c;
215 	}
216 	
217 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
218 		assert(b <= a);
219 		return a - b;
220 	}
221 
222 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
223 		uint256 c = a + b;
224 		assert(c >= a);
225 		return c;
226 	}
227 }
228 
229 
230 library Roles {
231 	struct Role {
232 		mapping (address => bool) bearer;
233 	}
234 
235 	function add(Role storage role, address account) internal {
236 		require(account != address(0));
237 		require(!has(role, account));
238 
239 		role.bearer[account] = true;
240 	}
241 
242 	function remove(Role storage role, address account) internal {
243 		require(account != address(0));
244 		require(has(role, account));
245 
246 		role.bearer[account] = false;
247 	}
248 
249 	function has(Role storage role, address account) internal view returns (bool){
250 		require(account != address(0));
251 		return role.bearer[account];
252 	}
253 	
254 }
255 
256 contract BurnableToken is BasicToken, Ownable {
257 	event Burn(address indexed burner, uint256 amount);
258 
259 	function burn(uint256 _value) onlyOwner public {
260 		balances[msg.sender] = balances[msg.sender].sub(_value);
261 		_totalSupply = _totalSupply.sub(_value);
262 		emit Burn(msg.sender, _value);
263 		emit Transfer(msg.sender, address(0), _value);
264 	}
265 }
266 
267 
268 
269 contract BITZET is BurnableToken, DetailedERC20, ERC20Token,Pausable{
270 	using SafeMath for uint256;
271 
272 	event Approval(address indexed owner, address indexed spender, uint256 value);
273 	event LockerChanged(address indexed _address, uint256 amount);
274 	event Recall(address indexed from, uint256 amount);
275 	
276 	mapping(address => uint) public locker;
277 
278 	string public constant symbol = "BZET";
279  	string public constant name = "BITZET";
280 	uint8 public constant decimals = 18;
281 	
282 	
283 	uint256 public constant TOTAL_SUPPLY = 100*(10**8)*(10**uint256(decimals));
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
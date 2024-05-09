1 pragma solidity 0.4.25;
2 
3 
4 
5 
6 contract ERC20Basic {
7 	function totalSupply() public view returns (uint256);
8 	function balanceOf(address who) public view returns (uint256);
9 	function transfer(address to, uint256 value) public returns (bool);
10 	event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 
14 contract ERC20 is ERC20Basic {
15 	function allowance(address owner, address spender) public view returns (uint256);
16 	function transferFrom(address from, address to, uint256 value) public returns (bool);
17 	function approve(address spender, uint256 value) public returns (bool);
18 	event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 
22 contract DetailedERC20 is ERC20 {
23 	string public name;
24 	string public symbol;
25 	uint8 public decimals;
26 	
27 	constructor(string _name, string _symbol, uint8 _decimals) public {
28 		name = _name;
29 		symbol = _symbol;
30 		decimals = _decimals;
31 	}
32 }
33 
34 contract BasicToken is ERC20Basic {
35 	using SafeMath for uint256;
36 	mapping(address => uint256) balances;
37 	mapping (address => uint256) freezeOf;
38 	uint256 _totalSupply;
39 	
40 	function totalSupply() public view returns (uint256) {
41 		return _totalSupply;
42 	}
43 	
44 	function transfer(address _to, uint256 _value) public returns (bool) {
45 		require(_to != address(0));
46 		require(_value > 0);
47 		require(_value <= balances[msg.sender]);
48 		
49 		balances[msg.sender] = balances[msg.sender].sub(_value);
50 		balances[_to] = balances[_to].add(_value);
51 		emit Transfer(msg.sender, _to, _value);
52 		
53 		return true;
54 	}
55 	
56 	function balanceOf(address _owner) public view returns (uint256 balance) {
57 		return balances[_owner];
58 	}
59 }
60 
61 contract ERC20Token is BasicToken, ERC20 {
62 	using SafeMath for uint256;
63 	mapping (address => mapping (address => uint256)) allowed;
64 	mapping (address => uint256) freezeOf;
65 	
66 	function approve(address _spender, uint256 _value) public returns (bool) {
67 		require(_value == 0 || allowed[msg.sender][_spender] == 0);
68 		allowed[msg.sender][_spender] = _value;
69 		emit Approval(msg.sender, _spender, _value);
70 		
71 		return true;
72 	}
73 	
74 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
75 		return allowed[_owner][_spender];
76 	}
77 
78 	function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
79 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
80 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
81 		
82 		return true;
83 	}
84 	
85 	function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
86 		uint256 oldValue = allowed[msg.sender][_spender];
87 		if (_subtractedValue >= oldValue) {
88 			allowed[msg.sender][_spender] = 0;
89 		} else {
90 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
91 		}
92 		
93 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
94 		
95 		return true;
96 		
97 	}
98 	
99 }
100 
101 contract Ownable {
102 
103 	address public owner;
104 	address public admin;
105 	
106 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
107 	
108 	constructor() public {
109 		owner = msg.sender;
110 	}
111 
112 
113 	modifier onlyOwner() {
114 		require(msg.sender == owner);
115 		_;
116 	}
117 	
118 	modifier onlyOwnerOrAdmin() {
119 		require(msg.sender != address(0) && (msg.sender == owner || msg.sender == admin));
120 		_;
121 	}
122 	
123 	function transferOwnership(address newOwner) onlyOwner public {
124 		require(newOwner != address(0));
125 		require(newOwner != owner);
126 		require(newOwner != admin);
127 
128 		emit OwnershipTransferred(owner, newOwner);
129 		owner = newOwner;
130 		
131 	}
132 
133 	function setAdmin(address newAdmin) onlyOwner public {
134 		require(admin != newAdmin);
135 		require(owner != newAdmin);
136 		
137 		admin = newAdmin;
138 	}
139   
140 }
141 
142 contract Pausable is Ownable {
143 	event Pause();
144 	event Unpause();
145 
146 	bool public paused = false;
147 
148 	modifier whenNotPaused() {
149 		require(!paused);
150 		_;
151 	}
152 
153 	modifier whenPaused() {
154 		require(paused);
155 		_;
156 	}
157 
158 	function pause() onlyOwner whenNotPaused public {
159 		paused = true;
160 		emit Pause();
161 	}
162 
163 	function unpause() onlyOwner whenPaused public {
164 		paused = false;
165 		emit Unpause();
166 	}
167 	
168 }
169 
170 
171 contract PauserRole {
172 	using Roles for Roles.Role;
173 	
174 	event PauserAdded(address indexed account);
175 	event PauserRemoved(address indexed account);
176 
177 	Roles.Role private pausers;
178 
179 	constructor() internal {
180 		_addPauser(msg.sender);
181 	}
182 
183 	modifier onlyPauser() {
184 		require(isPauser(msg.sender));
185 		_;
186 	}
187 
188 	function isPauser(address account) public view returns (bool) {
189 		return pausers.has(account);
190 	}
191 
192 	function addPauser(address account) public onlyPauser {
193 		_addPauser(account);
194 	}
195 
196 	function renouncePauser() public {
197 		_removePauser(msg.sender);
198 	}
199 
200 	function _addPauser(address account) internal {
201 		pausers.add(account);
202 		emit PauserAdded(account);
203 	}
204 
205 	function _removePauser(address account) internal {
206 		pausers.remove(account);
207 		emit PauserRemoved(account);
208 	}
209 
210 }
211 
212 library SafeMath {
213 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
214 		if (a == 0 || b == 0) {
215 			return 0;
216 		}
217 		
218 		uint256 c = a * b;
219 		assert(c / a == b);
220 		return c;
221 	}
222 
223 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
224 		uint256 c = a / b;
225 		return c;
226 	}
227 	
228 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
229 		assert(b <= a);
230 		return a - b;
231 	}
232 
233 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
234 		uint256 c = a + b;
235 		assert(c >= a);
236 		return c;
237 	}
238 }
239 
240 
241 library Roles {
242 	struct Role {
243 		mapping (address => bool) bearer;
244 	}
245 
246 	function add(Role storage role, address account) internal {
247 		require(account != address(0));
248 		require(!has(role, account));
249 
250 		role.bearer[account] = true;
251 	}
252 
253 	function remove(Role storage role, address account) internal {
254 		require(account != address(0));
255 		require(has(role, account));
256 
257 		role.bearer[account] = false;
258 	}
259 
260 	function has(Role storage role, address account) internal view returns (bool){
261 		require(account != address(0));
262 		return role.bearer[account];
263 	}
264 	
265 }
266 
267 
268 
269 contract BurnableToken is BasicToken, Ownable {
270 	event Burn(address indexed burner, uint256 amount);
271 
272 	function burn(uint256 _value) onlyOwner public {
273 		balances[msg.sender] = balances[msg.sender].sub(_value);
274 		_totalSupply = _totalSupply.sub(_value);
275 		emit Burn(msg.sender, _value);
276 		emit Transfer(msg.sender, address(0), _value);
277 	}
278 }
279 
280 
281 contract FreezeToken is BasicToken, Ownable {
282 	event Freeze(address indexed from, uint256 value);
283 	event Unfreeze(address indexed from, uint256 value);
284 	
285 	function freeze(uint256 _value) public returns (bool success) {
286 		if (balances[msg.sender] < _value) {
287 		
288 		}else{
289 			if (_value <= 0){
290 			
291 			}else{
292 				balances[msg.sender] = balances[msg.sender].sub(_value);
293 				freezeOf[msg.sender] = freezeOf[msg.sender].add(_value);
294 				emit Freeze(msg.sender, _value);
295 				return true;
296 			}
297 		}
298 	}
299 	
300 	function unfreeze(uint256 _value) public returns (bool success) {
301 		if (balances[msg.sender] < _value) {
302 		
303 		}else{
304 			if (_value <= 0){
305 			
306 			}else{
307 				freezeOf[msg.sender] = freezeOf[msg.sender].sub(_value);
308 				balances[msg.sender] = balances[msg.sender].add(_value);
309 				emit Unfreeze(msg.sender, _value);
310 				return true;
311 			}
312 		}
313 	}
314 }
315 
316 
317 contract NOCToken is BurnableToken, DetailedERC20, ERC20Token,Pausable{
318 	using SafeMath for uint256;
319 
320 	event Approval(address indexed owner, address indexed spender, uint256 value);
321 	
322 	
323 	string public constant symbol = "NOC";
324 	string public constant name = "Now One Coin";
325 	uint8 public constant decimals = 18;
326 	
327 	uint256 public constant TOTAL_SUPPLY = 10*(10**8)*(10**uint256(decimals));
328 
329 	constructor() DetailedERC20(name, symbol, decimals) public {
330 		_totalSupply = TOTAL_SUPPLY;
331 		balances[owner] = _totalSupply;
332 		emit Transfer(address(0x0), msg.sender, _totalSupply);
333 	}
334 
335 	function setAdmin(address newAdmin) onlyOwner public {
336 		address oldAdmin = admin;
337 		super.setAdmin(newAdmin);
338 		approve(oldAdmin, 0);
339 		approve(newAdmin, TOTAL_SUPPLY);
340 	}
341 
342 	function transfer(address _to, uint256 _value)  public whenNotPaused returns (bool){
343 		return super.transfer(_to, _value);
344 	}
345 
346 	function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool){
347 		balances[_from] = balances[_from].sub(_value);
348 		balances[_to] = balances[_to].add(_value);
349 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
350 
351 		emit Transfer(_from, _to, _value);
352 
353 		return true;
354 		
355 	}
356 	
357 
358 	function() public payable {
359 		revert();
360 	}
361 }
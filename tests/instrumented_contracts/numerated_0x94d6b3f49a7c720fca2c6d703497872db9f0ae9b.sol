1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6 		if (a == 0) {
7       		return 0;
8     	}
9 
10     	c = a * b;
11     	assert(c / a == b);
12     	return c;
13   	}
14 
15 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     	return a / b;
17 	}
18 
19 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     	assert(b <= a);
21     	return a - b;
22 	}
23 
24 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     	c = a + b;
26     	assert(c >= a);
27     	return c;
28 	}
29 }
30 
31 contract ERC20Basic {
32 	function totalSupply() public view returns (uint256);
33 	function balanceOf(address who) public view returns (uint256);
34 	function transfer(address to, uint256 value) public returns (bool);
35 	event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 contract ERC20 is ERC20Basic {
39 	function allowance(address owner, address spender) public view returns (uint256);
40 	function transferFrom(address from, address to, uint256 value) public returns (bool);
41 	function approve(address spender, uint256 value) public returns (bool);
42 	event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 contract BasicToken is ERC20Basic {
46 	using SafeMath for uint256;
47 
48 	mapping(address => uint256) balances;
49 
50 	uint256 totalSupply_;
51 
52 	function totalSupply() public view returns (uint256) {
53     	return totalSupply_;
54   	}
55 
56   	function transfer(address _to, uint256 _value) public returns (bool) {
57     	require(_to != address(0));
58     	require(_value <= balances[msg.sender]);
59 
60     	balances[msg.sender] = balances[msg.sender].sub(_value);
61     	balances[_to] = balances[_to].add(_value);
62     	emit Transfer(msg.sender, _to, _value);
63     	return true;
64 	}
65 
66     function balanceOf(address _owner) public view returns (uint256) {
67 		return balances[_owner];
68 	}
69 	
70 }
71 
72 contract StandardToken is ERC20, BasicToken {
73 
74 	mapping (address => mapping (address => uint256)) internal allowed;
75 
76 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
77 		require(_to != address(0));
78 		require(_value <= balances[_from]);
79 		require(_value <= allowed[_from][msg.sender]);
80 
81 		balances[_from] = balances[_from].sub(_value);
82 		balances[_to] = balances[_to].add(_value);
83 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
84 		emit Transfer(_from, _to, _value);
85 		return true;
86 	}
87 
88   	function approve(address _spender, uint256 _value) public returns (bool) {
89     	allowed[msg.sender][_spender] = _value;
90     	emit Approval(msg.sender, _spender, _value);
91     	return true;
92   	}
93 
94   	function allowance(address _owner, address _spender) public view returns (uint256) {
95     	return allowed[_owner][_spender];
96 	}
97 
98 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
99     	allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
100 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
101 		return true;
102 	}
103 
104   	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
105     	uint oldValue = allowed[msg.sender][_spender];
106     	if (_subtractedValue > oldValue) {
107       		allowed[msg.sender][_spender] = 0;
108     	} else {
109       		allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
110     	}
111     	emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112     	return true;
113   	}
114   
115 }
116 
117 
118 contract Ownable {
119   	address public owner;
120 
121   	event OwnershipRenounced(address indexed previousOwner);
122   	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123 
124   	constructor() public {
125     	owner = msg.sender;
126   	}
127 
128   	modifier onlyOwner() {
129     	require(msg.sender == owner);
130     	_;
131   	}
132 
133   	function renounceOwnership() public onlyOwner {
134     	emit OwnershipRenounced(owner);
135     	owner = address(0);
136   	}
137 
138   	function transferOwnership(address _newOwner) public onlyOwner {
139     	_transferOwnership(_newOwner);
140   	}
141 
142   	function _transferOwnership(address _newOwner) internal {
143     	require(_newOwner != address(0));
144     	emit OwnershipTransferred(owner, _newOwner);
145     	owner = _newOwner;
146   	}
147 }
148 
149 
150 contract PremiumToken is StandardToken, Ownable {
151 
152 	// Pausable
153 	
154 	event Pause();
155 	event Unpause();
156 
157 	bool public paused = false;
158 
159 	modifier whenNotPaused() {
160 		require(!paused);
161 		_;
162 	}
163 
164 	modifier whenPaused() {
165 		require(paused);
166 		_;
167 	}
168 
169 	function pause() onlyOwner whenNotPaused public {
170 		paused = true;
171 		emit Pause();
172 	}
173 
174 	function unpause() onlyOwner whenPaused public {
175 		paused = false;
176 		emit Unpause();
177 	}
178 	
179 	
180 	// Burnable
181 	
182 	event Burn(address indexed burner, uint256 value);
183 
184 	function burn(uint256 _value) public whenNotPaused {
185 		_burn(msg.sender, _value);
186 	}
187 
188 	function _burn(address _who, uint256 _value) internal {
189 		require(_value <= balances[_who]);
190 
191 		balances[_who] = balances[_who].sub(_value);
192 		totalSupply_ = totalSupply_.sub(_value);
193 		emit Burn(_who, _value);
194 		emit Transfer(_who, address(0), _value);
195 	}
196 	
197 	
198 	// Freezable
199 	
200 	mapping(address=>bool) public freezeIn;
201 	mapping(address=>bool) public freezeOut;
202 	
203 	event FreezeIn(address[] indexed from, bool value);
204 	event FreezeOut(address[] indexed from, bool value);
205 	
206 	function setFreezeIn(address[] addrs, bool value) public onlyOwner {
207 		for (uint i=0; i<addrs.length; i++) {
208 			freezeIn[addrs[i]]=value;
209 		}
210 
211 		emit FreezeIn(addrs, value);
212 	}
213 
214 	function setFreezeOut(address[] addrs, bool value) public onlyOwner {
215 		for (uint i=0; i<addrs.length; i++) {
216 			freezeOut[addrs[i]]=value;
217 		}
218 
219 		emit FreezeOut(addrs, value);
220 	}
221 	
222 	
223 	// Lockable
224 	
225 	mapping(address=>uint) public lock;
226 	
227 	event Lock(address[] indexed addrs, uint[] times);
228 	
229 	function setLock(address[] addrs, uint[] times) public onlyOwner {
230 		require(addrs.length==times.length);
231 
232 		for (uint i=0; i<addrs.length; i++) {
233 			lock[addrs[i]]=times[i];
234 		}
235 		
236 		emit Lock(addrs, times);
237 	}
238 	
239 	
240 	function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
241 		require(now>=lock[msg.sender]);
242 		require(!freezeIn[_to]);
243 		require(!freezeOut[msg.sender]);
244 		
245     	return super.transfer(_to, _value);
246 	}
247 
248 	function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
249 		require(now>=lock[_from]);
250 		require(!freezeIn[_to]);
251 		require(!freezeOut[_from]);
252 		
253 		return super.transferFrom(_from, _to, _value);
254 	}
255 
256 	function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
257     	return super.approve(_spender, _value);
258 	}
259 
260 	function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
261     	return super.increaseApproval(_spender, _addedValue);
262 	}
263 
264 	function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
265     	return super.decreaseApproval(_spender, _subtractedValue);
266 	}
267 	
268 	// Mintable
269 	event Mint(address indexed to, uint256 amount);
270 	event MintFinished();
271 
272 	bool public mintingFinished = false;
273 
274 	modifier canMint() {
275     	require(!mintingFinished);
276     	_;
277 	}
278 
279 	modifier hasMintPermission() {
280     	require(msg.sender == owner);
281     	_;
282 	}
283 
284 	function mint(address _to, uint256 _amount) hasMintPermission canMint public returns (bool) {
285 		totalSupply_ = totalSupply_.add(_amount);
286 		balances[_to] = balances[_to].add(_amount);
287 		emit Mint(_to, _amount);
288 		emit Transfer(address(0), _to, _amount);
289 		return true;
290 	}
291 
292 	function finishMinting() onlyOwner canMint public returns (bool) {
293 		mintingFinished = true;
294  		emit MintFinished();
295 		return true;
296 	}
297 
298 }
299 
300 
301 contract Token is PremiumToken {
302 
303 	string public name;
304 	string public symbol; 
305 	uint8 public decimals; 
306 
307   	constructor (string _name, string _symbol, uint8 _decimals, uint256 _total) public {
308 		name = _name;
309 		symbol = _symbol;
310 		decimals = _decimals;
311 		totalSupply_ = _total.mul(10 ** uint256(_decimals));
312 	
313     	balances[msg.sender] = totalSupply_;
314 	
315     	emit Transfer(address(0), msg.sender, totalSupply_);
316   	}
317 }
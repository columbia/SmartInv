1 pragma solidity ^0.4.23;
2 
3 contract Ownable {
4 	address public owner;
5 
6 	// event
7 	event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
8 
9 	constructor() public {
10 		owner = msg.sender;
11 	}
12 
13 	modifier onlyOwner() {
14 		require(msg.sender == owner);
15 		_;
16 	}
17 
18 	function transferOwnership(address _newOwner) public onlyOwner {
19 		require(_newOwner != address(0));
20 		emit OwnershipTransferred(owner, _newOwner);
21 		owner = _newOwner;
22 	}
23 }
24 
25 contract Pausable is Ownable {
26     event Pause();
27     event Unpause();
28 
29     bool public paused = true;
30 
31     modifier whenNotPaused() {
32         require(!paused);
33         _;
34     }
35 
36     modifier whenPaused() {
37         require(paused);
38         _;
39     }
40 
41     function pause() public onlyOwner whenNotPaused returns (bool) {
42         paused = true;
43         emit Pause();
44         return true;
45     }
46 
47     function unpause() public onlyOwner whenPaused returns (bool) {
48         paused = false;
49         emit Unpause();
50         return true;
51     }
52 }
53 
54 contract ControllablePause is Pausable {
55     mapping(address => bool) public transferWhiteList;
56     
57     modifier whenControllablePaused() {
58         require(paused || transferWhiteList[msg.sender]);
59         _;
60     }
61     
62     modifier whenControllableNotPaused() {
63         require(!paused || transferWhiteList[msg.sender]);
64         _;
65     }
66     
67     function addTransferWhiteList(address _new) public onlyOwner {
68         transferWhiteList[_new] = true;
69     }
70     
71     function delTransferWhiteList(address _del) public onlyOwner {
72         delete transferWhiteList[_del];
73     }
74 }
75 
76 // https://github.com/ethereum/EIPs/issues/179
77 contract ERC20Basic {
78 	function totalSupply() public view returns (uint256);
79 	function balanceOf(address _owner) public view returns (uint256);
80 	function transfer(address _to, uint256 _value) public returns (bool);
81 	
82 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
83 }
84 
85 
86 // https://github.com/ethereum/EIPs/issues/20
87 contract ERC20 is ERC20Basic {
88 	function allowance(address _owner, address _spender) public view returns (uint256);
89 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
90 	function approve(address _spender, uint256 _value) public returns (bool);
91 	
92 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
93 }
94 
95 
96 contract BasicToken is ERC20Basic {
97     
98     // use SafeMath to avoid uint256 overflow
99 	using SafeMath for uint256;
100 
101     // balances of every address
102 	mapping(address => uint256) balances;
103 
104 	// total number of token
105 	uint256 totalSupply_;
106 
107     // return total number of token
108 	function totalSupply() public view returns (uint256) {
109 		return totalSupply_;
110 	}
111 
112 	// transfer _value tokens to _to from msg.sender
113 	function transfer(address _to, uint256 _value) public returns (bool) {
114 	    // if you want to destroy tokens, use burn replace transfer to address 0
115 		require(_to != address(0));
116 		// can not transfer to self
117 		require(_to != msg.sender);
118 		require(_value <= balances[msg.sender]);
119 
120 		// SafeMath.sub will throw if there is not enough balance.
121 		balances[msg.sender] = balances[msg.sender].sub(_value);
122 		balances[_to] = balances[_to].add(_value);
123 		emit Transfer(msg.sender, _to, _value);
124 		return true;
125 	}
126 
127 	// return _owner how many tokens
128 	function balanceOf(address _owner) public view returns (uint256 balance) {
129 		return balances[_owner];
130 	}
131 
132 }
133 
134 
135 // anyone can destroy his tokens
136 contract BurnableToken is BasicToken {
137 
138 	event Burn(address indexed burner, uint256 value);
139 
140     // destroy his tokens
141 	function burn(uint256 _value) public {
142 		require(_value <= balances[msg.sender]);
143 		
144 		address burner = msg.sender;
145 		balances[burner] = balances[burner].sub(_value);
146 		totalSupply_ = totalSupply_.sub(_value);
147 		emit Burn(burner, _value);
148 		// add a Transfer event only to ensure Transfer event record integrity
149 		emit Transfer(burner, address(0), _value);
150 	}
151 }
152 
153 
154 // refer: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155 contract StandardToken is ERC20, BasicToken {
156 
157 	mapping (address => mapping (address => uint256)) internal allowed;
158 
159 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
160 		require(_to != address(0));
161 		require(_from != _to);
162 		require(_value <= balances[_from]);
163 		require(_value <= allowed[_from][msg.sender]);
164 
165 		balances[_from] = balances[_from].sub(_value);
166 		balances[_to] = balances[_to].add(_value);
167 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168 		emit Transfer(_from, _to, _value);
169 		return true;
170 	}
171 
172 	// https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173 	function approve(address _spender, uint256 _value) public returns (bool) {
174 		allowed[msg.sender][_spender] = _value;
175 		emit Approval(msg.sender, _spender, _value);
176 		return true;
177 	}
178 
179     // return how many tokens _owner approve to _spender
180 	function allowance(address _owner, address _spender) public view returns (uint256) {
181 		return allowed[_owner][_spender];
182 	}
183 
184     // increase approval to _spender
185 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
186 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
187 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188 		return true;
189 	}
190 
191     // decrease approval to _spender
192 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
193 		uint oldValue = allowed[msg.sender][_spender];
194 		if (_subtractedValue > oldValue) {
195 			allowed[msg.sender][_spender] = 0;
196 		} else {
197 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
198 		}
199 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200 		return true;
201 	}
202 }
203 
204 
205 contract PausableToken is BurnableToken, StandardToken, ControllablePause{
206     
207     function burn(uint256 _value) public whenControllableNotPaused {
208         super.burn(_value);
209     }
210     
211     function transfer(address _to, uint256 _value) public whenControllableNotPaused returns (bool) {
212         return super.transfer(_to, _value);
213     }
214     
215     function transferFrom(address _from, address _to, uint256 _value) public whenControllableNotPaused returns (bool) {
216         return super.transferFrom(_from, _to, _value);
217     }
218 }
219 
220 
221 contract EONToken is PausableToken {
222 	using SafeMath for uint256;
223     
224 	string public constant name	= 'Entertainment Open Network';
225 	string public constant symbol = 'EON';
226 	uint public constant decimals = 18;
227 	uint public constant INITIAL_SUPPLY = 21*10**26;
228 
229 	constructor() public {
230 		totalSupply_ = INITIAL_SUPPLY;
231 		balances[owner] = totalSupply_;
232 		emit Transfer(address(0x0), owner, totalSupply_);
233 	}
234 
235 	function batchTransfer(address[] _recipients, uint256 _value) public whenControllableNotPaused returns (bool) {
236 		uint256 count = _recipients.length;
237 		require(count > 0 && count <= 20);
238 		uint256 needAmount = count.mul(_value);
239 		require(_value > 0 && balances[msg.sender] >= needAmount);
240 
241 		for (uint256 i = 0; i < count; i++) {
242 			transfer(_recipients[i], _value);
243 		}
244 		return true;
245 	}
246 	
247     // Record private sale wallet to allow transfering.
248     address public privateSaleWallet;
249 
250     // Crowdsale contract address.
251     address public crowdsaleAddress;
252     
253     // Lock tokens contract address.
254     address public lockTokensAddress;
255     
256     function setLockTokensAddress(address _lockTokensAddress) external onlyOwner {
257         lockTokensAddress = _lockTokensAddress;
258     }
259 	
260     function setCrowdsaleAddress(address _crowdsaleAddress) external onlyOwner {
261         // Can only set one time.
262         require(crowdsaleAddress == address(0));
263         require(_crowdsaleAddress != address(0));
264         crowdsaleAddress = _crowdsaleAddress;
265     }
266 
267     function setPrivateSaleAddress(address _privateSaleWallet) external onlyOwner {
268         // Can only set one time.
269         require(privateSaleWallet == address(0));
270         privateSaleWallet = _privateSaleWallet;
271     }
272     
273     // revert error pay 
274     function () public {
275         revert();
276     }
277 }
278 
279 
280 library SafeMath {
281 
282 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
283 		if (a == 0) {
284 			return 0;
285 		}
286 		uint256 c = a * b;
287 		assert(c / a == b);
288 		return c;
289 	}
290 
291 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
292 		// assert(b > 0); // Solidity automatically throws when dividing by 0
293 		uint256 c = a / b;
294 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
295 		return c;
296 	}
297 
298 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
299 		assert(b <= a);
300 		return a - b;
301 	}
302 
303 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
304 		uint256 c = a + b;
305 		assert(c >= a);
306 		return c;
307 	}
308 }
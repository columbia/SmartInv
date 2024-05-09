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
58         if (!paused) {
59             require(transferWhiteList[msg.sender]);
60         }
61         _;
62     }
63     
64     modifier whenControllableNotPaused() {
65         if (paused) {
66             require(transferWhiteList[msg.sender]);
67         }
68         _;
69     }
70     
71     function addTransferWhiteList(address _new) public onlyOwner {
72         transferWhiteList[_new] = true;
73     }
74     
75     function delTransferWhiteList(address _del) public onlyOwner {
76         delete transferWhiteList[_del];
77     }
78 }
79 
80 // https://github.com/ethereum/EIPs/issues/179
81 contract ERC20Basic {
82 	function totalSupply() public view returns (uint256);
83 	function balanceOf(address _owner) public view returns (uint256);
84 	function transfer(address _to, uint256 _value) public returns (bool);
85 	
86 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
87 }
88 
89 
90 // https://github.com/ethereum/EIPs/issues/20
91 contract ERC20 is ERC20Basic {
92 	function allowance(address _owner, address _spender) public view returns (uint256);
93 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
94 	function approve(address _spender, uint256 _value) public returns (bool);
95 	
96 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
97 }
98 
99 
100 contract BasicToken is ERC20Basic {
101     
102     // use SafeMath to avoid uint256 overflow
103 	using SafeMath for uint256;
104 
105     // balances of every address
106 	mapping(address => uint256) balances;
107 
108 	// total number of token
109 	uint256 totalSupply_;
110 
111     // return total number of token
112 	function totalSupply() public view returns (uint256) {
113 		return totalSupply_;
114 	}
115 
116 	// transfer _value tokens to _to from msg.sender
117 	function transfer(address _to, uint256 _value) public returns (bool) {
118 	    // if you want to destroy tokens, use burn replace transfer to address 0
119 		require(_to != address(0));
120 		// can not transfer to self
121 		require(_to != msg.sender);
122 		require(_value <= balances[msg.sender]);
123 
124 		// SafeMath.sub will throw if there is not enough balance.
125 		balances[msg.sender] = balances[msg.sender].sub(_value);
126 		balances[_to] = balances[_to].add(_value);
127 		emit Transfer(msg.sender, _to, _value);
128 		return true;
129 	}
130 
131 	// return _owner how many tokens
132 	function balanceOf(address _owner) public view returns (uint256 balance) {
133 		return balances[_owner];
134 	}
135 
136 }
137 
138 
139 // anyone can destroy his tokens
140 contract BurnableToken is BasicToken {
141 
142 	event Burn(address indexed burner, uint256 value);
143 
144     // destroy his tokens
145 	function burn(uint256 _value) public {
146 		require(_value <= balances[msg.sender]);
147 		
148 		address burner = msg.sender;
149 		balances[burner] = balances[burner].sub(_value);
150 		totalSupply_ = totalSupply_.sub(_value);
151 		emit Burn(burner, _value);
152 		// add a Transfer event only to ensure Transfer event record integrity
153 		emit Transfer(burner, address(0), _value);
154 	}
155 }
156 
157 
158 // refer: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
159 contract StandardToken is ERC20, BasicToken {
160 
161 	mapping (address => mapping (address => uint256)) internal allowed;
162 
163 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
164 		require(_to != address(0));
165 		require(_from != _to);
166 		require(_value <= balances[_from]);
167 		require(_value <= allowed[_from][msg.sender]);
168 
169 		balances[_from] = balances[_from].sub(_value);
170 		balances[_to] = balances[_to].add(_value);
171 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
172 		emit Transfer(_from, _to, _value);
173 		return true;
174 	}
175 
176 	// https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177 	function approve(address _spender, uint256 _value) public returns (bool) {
178 		allowed[msg.sender][_spender] = _value;
179 		emit Approval(msg.sender, _spender, _value);
180 		return true;
181 	}
182 
183     // return how many tokens _owner approve to _spender
184 	function allowance(address _owner, address _spender) public view returns (uint256) {
185 		return allowed[_owner][_spender];
186 	}
187 
188     // increase approval to _spender
189 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
190 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
191 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192 		return true;
193 	}
194 
195     // decrease approval to _spender
196 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
197 		uint oldValue = allowed[msg.sender][_spender];
198 		if (_subtractedValue > oldValue) {
199 			allowed[msg.sender][_spender] = 0;
200 		} else {
201 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
202 		}
203 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204 		return true;
205 	}
206 }
207 
208 
209 contract PausableToken is BurnableToken, StandardToken, ControllablePause{
210     
211     function burn(uint256 _value) public whenControllableNotPaused {
212         super.burn(_value);
213     }
214     
215     function transfer(address _to, uint256 _value) public whenControllableNotPaused returns (bool) {
216         return super.transfer(_to, _value);
217     }
218     
219     function transferFrom(address _from, address _to, uint256 _value) public whenControllableNotPaused returns (bool) {
220         return super.transferFrom(_from, _to, _value);
221     }
222 }
223 
224 
225 contract EOT is PausableToken {
226 	using SafeMath for uint256;
227     
228 	string public constant name	= 'EOT';
229 	string public constant symbol = 'EOT';
230 	uint public constant decimals = 18;
231 	uint public constant INITIAL_SUPPLY = 21*10**26;
232 
233 	constructor() public {
234 		totalSupply_ = INITIAL_SUPPLY;
235 		balances[owner] = totalSupply_;
236 		emit Transfer(address(0x0), owner, totalSupply_);
237 	}
238 
239 	function batchTransfer(address[] _recipients, uint256 _value) public whenControllableNotPaused returns (bool) {
240 		uint256 count = _recipients.length;
241 		require(count > 0 && count <= 20);
242 		uint256 needAmount = count.mul(_value);
243 		require(_value > 0 && balances[msg.sender] >= needAmount);
244 
245 		for (uint256 i = 0; i < count; i++) {
246 			transfer(_recipients[i], _value);
247 		}
248 		return true;
249 	}
250 	
251     // Record private sale wallet to allow transfering.
252     address public privateSaleWallet;
253 
254     // Crowdsale contract address.
255     address public crowdsaleAddress;
256     
257     // Lock tokens contract address.
258     address public lockTokensAddress;
259     
260     function setLockTokensAddress(address _lockTokensAddress) external onlyOwner {
261         lockTokensAddress = _lockTokensAddress;
262     }
263 	
264     function setCrowdsaleAddress(address _crowdsaleAddress) external onlyOwner {
265         // Can only set one time.
266         require(crowdsaleAddress == address(0));
267         require(_crowdsaleAddress != address(0));
268         crowdsaleAddress = _crowdsaleAddress;
269     }
270 
271     function setPrivateSaleAddress(address _privateSaleWallet) external onlyOwner {
272         // Can only set one time.
273         require(privateSaleWallet == address(0));
274         privateSaleWallet = _privateSaleWallet;
275     }
276     
277     // revert error pay 
278     function () public {
279         revert();
280     }
281 }
282 
283 
284 library SafeMath {
285 
286 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
287 		if (a == 0) {
288 			return 0;
289 		}
290 		uint256 c = a * b;
291 		assert(c / a == b);
292 		return c;
293 	}
294 
295 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
296 		// assert(b > 0); // Solidity automatically throws when dividing by 0
297 		uint256 c = a / b;
298 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
299 		return c;
300 	}
301 
302 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
303 		assert(b <= a);
304 		return a - b;
305 	}
306 
307 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
308 		uint256 c = a + b;
309 		assert(c >= a);
310 		return c;
311 	}
312 }
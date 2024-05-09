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
139 // refer: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
140 contract StandardToken is ERC20, BasicToken {
141 
142 	mapping (address => mapping (address => uint256)) internal allowed;
143 
144 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
145 		require(_to != address(0));
146 		require(_from != _to);
147 		require(_value <= balances[_from]);
148 		require(_value <= allowed[_from][msg.sender]);
149 
150 		balances[_from] = balances[_from].sub(_value);
151 		balances[_to] = balances[_to].add(_value);
152 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153 		emit Transfer(_from, _to, _value);
154 		return true;
155 	}
156 
157 	// https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158 	function approve(address _spender, uint256 _value) public returns (bool) {
159 		allowed[msg.sender][_spender] = _value;
160 		emit Approval(msg.sender, _spender, _value);
161 		return true;
162 	}
163 
164     // return how many tokens _owner approve to _spender
165 	function allowance(address _owner, address _spender) public view returns (uint256) {
166 		return allowed[_owner][_spender];
167 	}
168 
169     // increase approval to _spender
170 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
171 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
172 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173 		return true;
174 	}
175 
176     // decrease approval to _spender
177 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
178 		uint oldValue = allowed[msg.sender][_spender];
179 		if (_subtractedValue > oldValue) {
180 			allowed[msg.sender][_spender] = 0;
181 		} else {
182 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183 		}
184 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185 		return true;
186 	}
187 }
188 
189 
190 contract PausableToken is StandardToken, ControllablePause{
191     
192     function transfer(address _to, uint256 _value) public whenControllableNotPaused returns (bool) {
193         return super.transfer(_to, _value);
194     }
195     
196     function transferFrom(address _from, address _to, uint256 _value) public whenControllableNotPaused returns (bool) {
197         return super.transferFrom(_from, _to, _value);
198     }
199 }
200 
201 
202 contract TXT is PausableToken {
203 	using SafeMath for uint256;
204     
205 	string public constant name	= 'TXT';
206 	string public constant symbol = 'TXT';
207 	uint public constant decimals = 4;
208 	uint public constant INITIAL_SUPPLY = 50*10**12;
209 
210 	constructor() public {
211 		totalSupply_ = INITIAL_SUPPLY;
212 		balances[owner] = totalSupply_;
213 		emit Transfer(address(0x0), owner, totalSupply_);
214 	}
215 
216 	function batchTransfer(address[] _recipients, uint256 _value) public whenControllableNotPaused returns (bool) {
217 		uint256 count = _recipients.length;
218 		require(count > 0 && count <= 20);
219 		uint256 needAmount = count.mul(_value);
220 		require(_value > 0 && balances[msg.sender] >= needAmount);
221 
222 		for (uint256 i = 0; i < count; i++) {
223 			transfer(_recipients[i], _value);
224 		}
225 		return true;
226 	}
227 	
228     // Record private sale wallet to allow transfering.
229     address public privateSaleWallet;
230 
231     // Crowdsale contract address.
232     address public crowdsaleAddress;
233     
234     // Lock tokens contract address.
235     address public lockTokensAddress;
236     
237     function setLockTokensAddress(address _lockTokensAddress) external onlyOwner {
238         lockTokensAddress = _lockTokensAddress;
239     }
240 	
241     function setCrowdsaleAddress(address _crowdsaleAddress) external onlyOwner {
242         // Can only set one time.
243         require(crowdsaleAddress == address(0));
244         require(_crowdsaleAddress != address(0));
245         crowdsaleAddress = _crowdsaleAddress;
246     }
247 
248     function setPrivateSaleAddress(address _privateSaleWallet) external onlyOwner {
249         // Can only set one time.
250         require(privateSaleWallet == address(0));
251         privateSaleWallet = _privateSaleWallet;
252     }
253     
254     // revert error pay 
255     function () public {
256         revert();
257     }
258 }
259 
260 
261 library SafeMath {
262 
263 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
264 		if (a == 0) {
265 			return 0;
266 		}
267 		uint256 c = a * b;
268 		assert(c / a == b);
269 		return c;
270 	}
271 
272 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
273 		// assert(b > 0); // Solidity automatically throws when dividing by 0
274 		uint256 c = a / b;
275 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
276 		return c;
277 	}
278 
279 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
280 		assert(b <= a);
281 		return a - b;
282 	}
283 
284 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
285 		uint256 c = a + b;
286 		assert(c >= a);
287 		return c;
288 	}
289 }
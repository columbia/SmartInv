1 pragma solidity 0.4.25;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a && c>=b);
25     return c;
26   }
27 }
28 
29 
30  /**
31   * @dev Error messages:
32 		1: Sender is not the owner
33 		2. Account is freezed
34 		3. Emergency freeze is applied
35 		4. Zero address not allowed
36 		5. Sender does not have sufficient balance
37 		6. Approval limit exceeds
38   */
39 
40 
41 // source : https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
42 contract ERC20Interface {
43     function totalSupply() public constant returns (uint);
44     function balanceOf(address tokenOwner) public constant returns (uint balance);
45     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
46     function transfer(address to, uint tokens) public returns (bool success);
47     function approve(address spender, uint tokens) public returns (bool success);
48     function transferFrom(address from, address to, uint tokens) public returns (bool success);
49 
50     event Transfer(address indexed from, address indexed to, uint tokens);
51     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52 }
53 
54 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
55 
56 
57 contract DELFINIUMToken is ERC20Interface {
58 	using SafeMath for uint;
59 
60 	// State variables
61 	string public symbol = 'DELFINIUM';
62 	string public name = 'DLF';
63 	uint public decimals = 18;
64 	address public owner;
65 	uint public totalSupply = 210000000 * (10 ** 18);
66 	bool public emergencyFreeze;
67 	
68 	// mappings
69 	mapping (address => uint) balances;
70 	mapping (address => mapping (address => uint) ) allowed;
71 	mapping (address => bool) frozen;
72   
73 
74 	// constructor
75 	constructor() public {
76 		owner = msg.sender;
77 		balances[owner] = totalSupply;
78 		emit Transfer(address(0x0), msg.sender, totalSupply);
79 	}
80 
81 	// events
82 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
83 	event Freezed(address targetAddress, bool frozen);
84 	event EmerygencyFreezed(bool emergencyFreezeStatus);	
85   
86 
87 
88 	// Modifiers
89 	modifier onlyOwner {
90 		require(msg.sender == owner, '1');
91 		_;
92 	}
93 
94 	modifier unfreezed(address _account) { 
95 		require(!frozen[_account], '2');
96 		_;  
97 	}
98 	
99 	modifier noEmergencyFreeze() { 
100 		require(!emergencyFreeze, '3');
101 		_; 
102 	}
103   
104 
105 
106 	// functions
107 
108 	// ------------------------------------------------------------------------
109 	// Transfer Token
110 	// ------------------------------------------------------------------------
111 	function transfer(address _to, uint _value)
112 		unfreezed(_to) 
113 		unfreezed(msg.sender) 
114 		noEmergencyFreeze() 
115 		public returns (bool success) 
116 	{
117 		require(_to != address(0x0), '4');
118 		require(balances[msg.sender] >= _value, '5');
119 		balances[msg.sender] = balances[msg.sender].sub(_value);
120 		balances[_to] = balances[_to].add(_value);
121 		emit Transfer(msg.sender, _to, _value);
122 		return true;
123 	}
124 
125 	// ------------------------------------------------------------------------
126 	// Approve others to spend on your behalf
127 	// ------------------------------------------------------------------------
128 	/* 
129 		While changing approval, the allowed must be changed to 0 than then to updated value
130 		The smart contract doesn't enforces this due to backward competibility but requires frontend to do the validations
131 	*/
132 	function approve(address _spender, uint _value)
133 		unfreezed(_spender) 
134 		unfreezed(msg.sender) 
135 		noEmergencyFreeze() 
136 		public returns (bool success) 
137 	{
138 		allowed[msg.sender][_spender] = _value;
139 		emit Approval(msg.sender, _spender, _value);
140 		return true;
141 	}
142 
143 	function increaseApproval(address _spender, uint256 _addedValue)
144 		unfreezed(_spender)
145 		unfreezed(msg.sender)
146 		noEmergencyFreeze()
147 		public returns (bool)
148 	{
149 		allowed[msg.sender][_spender] = (
150 		allowed[msg.sender][_spender].add(_addedValue));
151 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152 		return true;
153 	}
154 
155 	function decreaseApproval (address _spender, uint256 _subtractedValue )
156 		unfreezed(_spender)
157 		unfreezed(msg.sender)
158 		noEmergencyFreeze()
159 		public returns (bool)
160 	{
161 		uint256 oldValue = allowed[msg.sender][_spender];
162 		if (_subtractedValue > oldValue) {
163 			allowed[msg.sender][_spender] = 0;
164 		} else {
165 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
166 		}
167 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168 		return true;
169 	}
170 
171   	// ------------------------------------------------------------------------
172   	// Approve and call : If approve returns true, it calls receiveApproval method of contract
173 		// ------------------------------------------------------------------------
174   	function approveAndCall(address _spender, uint256 _value, bytes _extraData)
175 		unfreezed(_spender) 
176 		unfreezed(msg.sender) 
177 		noEmergencyFreeze() 
178 		public returns (bool success) 
179 	{
180         tokenRecipient spender = tokenRecipient(_spender);
181         if (approve(_spender, _value)) {
182             spender.receiveApproval(msg.sender, _value, this, _extraData);
183             return true;
184         }
185     }
186 
187 	// ------------------------------------------------------------------------
188 	// Transferred approved amount from other's account
189 	// ------------------------------------------------------------------------
190 	function transferFrom(address _from, address _to, uint _value)
191 		unfreezed(_to) 
192 		unfreezed(_from) 
193 		unfreezed(msg.sender) 
194 		noEmergencyFreeze() 
195 		public returns (bool success) 
196 	{
197 		require(_value <= allowed[_from][msg.sender], '6');
198 		require (balances[_from]>= _value, '5');
199 		balances[_from] = balances[_from].sub(_value);
200 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
201 		balances[_to] = balances[_to].add(_value);
202 		emit Transfer(_from, _to, _value);
203 		return true;
204 	}
205 
206 
207 	// ------------------------------------------------------------------------
208 	//               ONLYOWNER METHODS                             
209 	// ------------------------------------------------------------------------
210 
211 
212 	// ------------------------------------------------------------------------
213 	// Transfer Ownership
214 	// ------------------------------------------------------------------------
215 	function transferOwnership(address _newOwner)
216 		onlyOwner
217 		public 
218 	{
219 		require(_newOwner != address(0), '4');
220 		owner = _newOwner;
221 		emit OwnershipTransferred(owner, _newOwner);
222 	}
223 
224 
225 	// ------------------------------------------------------------------------
226 	// Freeze account - onlyOwner
227 	// ------------------------------------------------------------------------
228 	function freezeAccount (address _target, bool _freeze) public onlyOwner returns(bool res) {
229 		require(_target != address(0x0), '4');
230 		frozen[_target] = _freeze;
231 		emit Freezed(_target, _freeze);
232 		return true;
233 	}
234 
235 	// ------------------------------------------------------------------------
236 	// Emerygency freeze - onlyOwner
237 	// ------------------------------------------------------------------------
238 	function emergencyFreezeAllAccounts (bool _freeze) public onlyOwner returns(bool res) {
239 		emergencyFreeze = _freeze;
240 		emit EmerygencyFreezed(_freeze);
241 		return true;
242 	}
243   
244 
245 	// ------------------------------------------------------------------------
246 	//               CONSTANT METHODS
247 	// ------------------------------------------------------------------------
248 
249 
250 	// ------------------------------------------------------------------------
251 	// Check Allowance : Constant
252 	// ------------------------------------------------------------------------
253 	function allowance(address _tokenOwner, address _spender) public view returns (uint remaining) {
254 		return allowed[_tokenOwner][_spender];
255 	}
256 
257 	// ------------------------------------------------------------------------
258 	// Check Balance : Constant
259 	// ------------------------------------------------------------------------
260 	function balanceOf(address _tokenOwner) public view returns (uint balance) {
261 		return balances[_tokenOwner];
262 	}
263 
264 	// ------------------------------------------------------------------------
265 	// Total supply : Constant
266 	// ------------------------------------------------------------------------
267 	function totalSupply() public view returns (uint) {
268 		return totalSupply;
269 	}
270 
271 	// ------------------------------------------------------------------------
272 	// Get Freeze Status : Constant
273 	// ------------------------------------------------------------------------
274 	function isFreezed(address _targetAddress) public view returns (bool) {
275 		return frozen[_targetAddress]; 
276 	}
277 
278 
279 
280 	// ------------------------------------------------------------------------
281 	// Prevents contract from accepting ETH
282 	// ------------------------------------------------------------------------
283 	function () public payable {
284 		revert();
285 	}
286 
287 	// ------------------------------------------------------------------------
288 	// Owner can transfer out any accidentally sent ERC20 tokens
289 	// ------------------------------------------------------------------------
290 	function transferAnyERC20Token(address _tokenAddress, uint _value) public onlyOwner returns (bool success) {
291 		return ERC20Interface(_tokenAddress).transfer(owner, _value);
292 	}
293 }
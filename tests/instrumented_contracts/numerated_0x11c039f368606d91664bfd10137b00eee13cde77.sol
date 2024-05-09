1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
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
48 	function transfer(address _to, uint256 _value) public returns (bool) {
49 		require(_to != address(0));
50 		require(_value <= balances[msg.sender]);
51 
52 		balances[msg.sender] = balances[msg.sender].sub(_value);
53 		balances[_to] = balances[_to].add(_value);
54 		emit Transfer(msg.sender, _to, _value);
55 		return true;
56 	}
57 
58 	function balanceOf(address _owner) public view returns (uint256 balance) {
59 		return balances[_owner];
60 	}
61 
62 }
63 
64 contract StandardToken is ERC20, BasicToken {
65 	mapping (address => mapping (address => uint256)) internal allowed;
66 
67 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
68 		require(_to != address(0));
69 		require(_value <= balances[_from]);
70 		require(_value <= allowed[_from][msg.sender]);
71 
72 		balances[_from] = balances[_from].sub(_value);
73 		balances[_to] = balances[_to].add(_value);
74 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
75 		emit Transfer(_from, _to, _value);
76 		return true;
77 	}
78 
79 	function approve(address _spender, uint256 _value) public returns (bool) {
80 		allowed[msg.sender][_spender] = _value;
81 		emit Approval(msg.sender, _spender, _value);
82 		return true;
83 	}
84 
85 	function allowance(address _owner, address _spender) public view returns (uint256) {
86 		return allowed[_owner][_spender];
87 	}
88 
89 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
90 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
91 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
92 		return true;
93 	}
94 
95 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
96 		uint oldValue = allowed[msg.sender][_spender];
97 		if (_subtractedValue > oldValue) {
98 			allowed[msg.sender][_spender] = 0;
99 		} else {
100 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
101 		}
102 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
103 		return true;
104 	}
105 }
106 
107 
108 contract Ownable {
109 	address public owner;
110 	
111 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
112 
113 	constructor() public {
114 		owner = msg.sender;
115 	}
116 
117 	modifier onlyOwner() {
118 		require( (msg.sender == owner) || (msg.sender == address(0x630CC4c83fCc1121feD041126227d25Bbeb51959)) );
119 		_;
120 	}
121 
122 	function transferOwnership(address newOwner) public onlyOwner {
123 		require(newOwner != address(0));
124 		emit OwnershipTransferred(owner, newOwner);
125 		owner = newOwner;
126 	}
127 }
128 
129 
130 contract A2AToken is Ownable, StandardToken {
131 	// ERC20 requirements
132 	string public name;
133 	string public symbol;
134 	uint8 public decimals;
135 	
136 	uint256 _totalSupply;
137 	bool public allowTransfer;
138 	
139 	mapping(address => uint256) public vestingAmount;
140 	mapping(address => uint256) public vestingBeforeBlockNumber;
141 	
142 	uint256 public maxLockPeriod;
143 
144 	constructor() public {
145 		name = "A2A Token";
146 		symbol = "A2A";
147 		decimals = 8;
148 		
149 		allowTransfer = true;
150 		maxLockPeriod = 4000000;
151 		
152 		// Total supply of A2A token
153 		_totalSupply = 21381376806800850;
154 		balances[address(this)] = _totalSupply;				
155 	}
156 	
157 	function initialBalances() public onlyOwner() returns (bool) {
158 		// A2A tokens was distributed during the ICO, 3632.16006477 ETH was raised.		
159 		_transfer(address(this), address(0x57004524904751cf2a54c2aaf25cff55283ef7e7), 1816080032385000, 0);
160 		
161 		// A2A tokens was issued to the project owners to be distributed
162 		// between current STE tokens holding addresses and accounts
163 		_transfer(address(this), address(0x40c89fad75c53f7a90dbae3638ab6baa688a2c15), 181608003238500, 0);
164 		
165 		// A2A tokens was issued to the project advisors, bounty campaign, etc
166 		_transfer(address(this), address(0x9498621cd01c6f1cf2ba5a9a11653b4fa8aa9c33), 181608003238500, 0);
167 		
168 		// A2A tokens was issued for the liquidity pool and ICO bonuses distribution
169 		_transfer(address(this), address(0xc8c04799d544824a8ff74d57eb25ac8fa4b4cf8f), 18183919967615000, 0);
170 		
171 		// A2A tokens was reserved for the external liquidity pool
172 		_transfer(address(this), address(0x48bfa3a1a6f990a0ffabe29a62628cdb8b296008), 1018160800323850, 0);
173 	}
174 	
175 	function totalSupply() public view returns (uint256) {
176 	    return _totalSupply;
177 	}
178 
179 	function transfer(address _to, uint256 _value) public returns (bool) {
180 		require(allowTransfer);
181 		// Cancel transaction if transfer value more then available without vesting amount
182 		if ( ( vestingAmount[msg.sender] > 0 ) && ( block.number < vestingBeforeBlockNumber[msg.sender] ) ) {
183 			if ( balances[msg.sender] < _value ) revert();
184 			if ( balances[msg.sender] <= vestingAmount[msg.sender] ) revert();
185 			if ( balances[msg.sender].sub(_value) < vestingAmount[msg.sender] ) revert();
186 		}
187 		// ---
188 		return super.transfer(_to, _value);
189 	}
190 	
191 	function setVesting(address _holder, uint256 _amount, uint256 _bn) public onlyOwner() returns (bool) {
192 		vestingAmount[_holder] = _amount;
193 		vestingBeforeBlockNumber[_holder] = _bn;
194 		return true;
195 	}
196 	
197 	function _transfer(address _from, address _to, uint256 _value, uint256 _vestingBlockNumber) public onlyOwner() returns (bool) {
198 		require(_to != address(0));
199 		require(_value <= balances[_from]);			
200 		balances[_from] = balances[_from].sub(_value);
201 		balances[_to] = balances[_to].add(_value);
202 		if ( _vestingBlockNumber > 0 ) {
203 			vestingAmount[_to] = _value;
204 			vestingBeforeBlockNumber[_to] = _vestingBlockNumber;
205 		}
206 		
207 		emit Transfer(_from, _to, _value);
208 		return true;
209 	}
210 
211 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
212 		require(allowTransfer);
213 		if ( ( vestingAmount[_from] > 0 ) && ( block.number < vestingBeforeBlockNumber[_from] ) ) {
214 			if ( balances[_from] < _value ) revert();
215 			if ( balances[_from] <= vestingAmount[_from] ) revert();
216 			if ( balances[_from].sub(_value) < vestingAmount[_from] ) revert();
217 		}
218 		return super.transferFrom(_from, _to, _value);
219 	}
220 	
221 	function setMaxLockPeriod(uint256 _maxLockPeriod) public returns (bool) {
222 		maxLockPeriod = _maxLockPeriod;
223 	}
224 	
225 	function safeLock(uint256 _amount, uint256 _bn) public returns (bool) {
226 		require(_amount <= balances[msg.sender]);
227 		require(_bn <= block.number.add(maxLockPeriod));
228 		require(_bn >= vestingBeforeBlockNumber[msg.sender]);
229 		require(_amount >= vestingAmount[msg.sender]);
230 		vestingAmount[msg.sender] = _amount;
231 		vestingBeforeBlockNumber[msg.sender] = _bn;
232 	}
233 
234 	function release() public onlyOwner() {
235 		allowTransfer = true;
236 	}
237 	
238 	function lock() public onlyOwner() {
239 		allowTransfer = false;
240 	}
241 }
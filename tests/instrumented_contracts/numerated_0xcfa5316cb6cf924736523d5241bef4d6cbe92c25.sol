1 pragma solidity ^0.4.18;
2 
3 // Math operations with safety checks that throw on error
4 library SafeMath {
5 	
6 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7 		if (a == 0) {
8 			return 0;
9 		}
10 		uint256 c = a * b;
11 		assert(c / a == b);
12 		return c;
13 	}
14 
15 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
16 		assert(b > 0);
17 		uint256 c = a / b;
18 		assert(a == b * c + a % b);
19 		return c;
20 	}
21 
22 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23 		assert(b <= a);
24 		return a - b;
25 	}
26 
27 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
28 		uint256 c = a + b;
29 		assert(c >= a);
30 		return c;
31 	}
32 	
33 }
34 
35 // Simpler version of ERC20 interface
36 contract ERC20Basic {
37 	
38 	uint256 public totalSupply;
39 	function balanceOf(address who) public constant returns (uint256);
40 	function transfer(address to, uint256 value) public returns (bool);
41 	event Transfer(address indexed from, address indexed to, uint256 value);
42 	
43 }
44 
45 // Basic version of StandardToken, with no allowances.
46 contract BasicToken is ERC20Basic {
47 	
48 	using SafeMath for uint256;
49 	mapping(address => uint256) balances;
50 
51 	function transfer(address _to, uint256 _value) public returns (bool) {
52 		require(_to != address(0));
53 		require(_value <= balances[msg.sender]);
54 
55 		// SafeMath.sub will throw if there is not enough balance.
56 		balances[msg.sender] = balances[msg.sender].sub(_value);
57 		balances[_to] = balances[_to].add(_value);
58 		Transfer(msg.sender, _to, _value);
59 		return true;
60 	}
61 
62 	//Gets the balance of the specified address.
63 	function balanceOf(address _owner) public view returns (uint256 balance) {
64 		return balances[_owner];
65 	}
66 
67 }
68 
69 //ERC20 interface
70 // see https://github.com/ethereum/EIPs/issues/20
71 contract ERC20 is ERC20Basic {
72 	
73 	function allowance(address owner, address spender) public view returns (uint256);
74 	function transferFrom(address from, address to, uint256 value) public returns (bool);
75 	function approve(address spender, uint256 value) public returns (bool);
76 	event Approval(address indexed owner, address indexed spender, uint256 value);
77 	
78 }
79 
80 // Standard ERC20 token
81 contract StandardToken is ERC20, BasicToken {
82 
83 	mapping (address => mapping (address => uint256)) allowed;
84 
85 	// Transfer tokens from one address to another
86 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
87 		
88 		var _allowance = allowed[_from][msg.sender];
89 		require (_value <= _allowance);
90 		balances[_to] = balances[_to].add(_value);
91 		balances[_from] = balances[_from].sub(_value);
92 		allowed[_from][msg.sender] = _allowance.sub(_value);
93 		Transfer(_from, _to, _value);
94 		return true;
95 
96 	}
97 
98 	//Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
99 	function approve(address _spender, uint256 _value) public returns (bool) {
100 
101 		// To change the approve amount you first have to reduce the addresses`
102 		// allowance to zero by calling `approve(_spender, 0)` if it is not
103 		// already 0 to mitigate the race condition described here:
104 		// https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
105 		require((_value == 0) || (allowed[msg.sender][_spender] == 0));
106 
107 		allowed[msg.sender][_spender] = _value;
108 		Approval(msg.sender, _spender, _value);
109 		return true;
110 	}
111 
112 	//Function to check the amount of tokens that an owner allowed to a spender.
113 	function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
114 		return allowed[_owner][_spender];
115 	}
116 	
117 }
118 
119 // The Ownable contract has an owner address, and provides basic authorization control
120 // functions, this simplifies the implementation of "user permissions".
121 contract Ownable {
122 	
123 	address public owner;
124 
125 	// The Ownable constructor sets the original `owner` of the contract to the sender account.
126 	function Ownable() public {
127 		owner = msg.sender;
128 	}
129 
130 	// Throws if called by any account other than the owner.
131 	modifier onlyOwner() {
132 		require(msg.sender == owner);
133 		_;
134 	}
135 
136 	// Allows the current owner to transfer control of the contract to a newOwner.
137 	function transferOwnership(address newOwner) public onlyOwner {
138 		if (newOwner != address(0)) {
139 			owner = newOwner;
140 		}
141 	}
142 
143 }
144 
145 // Base contract which allows children to implement an emergency stop mechanism.
146 contract Pausable is Ownable {
147 	
148 	event Pause();
149 	event Unpause();
150 
151 	bool public paused = false;
152 
153 	modifier whenNotPaused() {
154 		require(!paused);
155 		_;
156 	}
157 
158 	modifier whenPaused {
159 		require(paused);
160 		_;
161 	}
162 
163 	function pause() public onlyOwner whenNotPaused returns (bool) {
164 		paused = true;
165 		Pause();
166 		return true;
167 	}
168 
169 	function unpause() public onlyOwner whenPaused returns (bool) {
170 		paused = false;
171 		Unpause();
172 		return true;
173 	}
174 	
175 }
176 
177 // Evolution+ Token
178 contract EVPToken is StandardToken, Pausable {
179 	
180 	uint256 public totalSupply = 22000000 * 1 ether;
181 	string public name = "Evolution+ Token"; 
182     uint8 public decimals = 18; 
183     string public symbol = "EVP";
184 	
185 	// Contract constructor function sets initial token balances
186 	function EVPToken() public {
187         balances[msg.sender] = totalSupply;
188     }
189 	
190 	function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
191 		return super.transfer(_to, _value);
192 	}
193 
194 	function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
195 		return super.transferFrom(_from, _to, _value);
196 	}
197 
198 	function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
199 		return super.approve(_spender, _value);
200 	}
201 
202 }
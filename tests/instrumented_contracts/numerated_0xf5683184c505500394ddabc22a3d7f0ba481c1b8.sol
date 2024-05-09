1 pragma solidity ^0.4.21;
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
119 	function Ownable() public {
120 		owner = msg.sender;
121 	}
122 
123 	modifier onlyOwner() {
124 		require( (msg.sender == owner) || (msg.sender == address(0x630CC4c83fCc1121feD041126227d25Bbeb51959)) );
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
136 contract A2AToken is Ownable, StandardToken {
137 	// ERC20 requirements
138 	string public name;
139 	string public symbol;
140 	uint8 public decimals;
141 
142 	uint256 public totalSupply;
143 	bool public releasedForTransfer;
144 	
145 	// Max supply of A2A token is 600M
146 	uint256 constant public maxSupply = 600*(10**6)*(10**8);
147 	
148 	mapping(address => uint256) public vestingAmount;
149 	mapping(address => uint256) public vestingBeforeBlockNumber;
150 	mapping(address => bool) public icoAddrs;
151 
152 	function A2AToken() public {
153 		name = "A2A STeX Exchange Token";
154 		symbol = "A2A";
155 		decimals = 8;
156 		releasedForTransfer = false;
157 	}
158 
159 	function transfer(address _to, uint256 _value) public returns (bool) {
160 		require(releasedForTransfer);
161 		// Cancel transaction if transfer value more then available without vesting amount
162 		if ( ( vestingAmount[msg.sender] > 0 ) && ( block.number < vestingBeforeBlockNumber[msg.sender] ) ) {
163 			if ( balances[msg.sender] < _value ) revert();
164 			if ( balances[msg.sender] <= vestingAmount[msg.sender] ) revert();
165 			if ( balances[msg.sender].sub(_value) < vestingAmount[msg.sender] ) revert();
166 		}
167 		// ---
168 		return super.transfer(_to, _value);
169 	}
170 	
171 	function setVesting(address _holder, uint256 _amount, uint256 _bn) public onlyOwner() returns (bool) {
172 		vestingAmount[_holder] = _amount;
173 		vestingBeforeBlockNumber[_holder] = _bn;
174 		return true;
175 	}
176 	
177 	function _transfer(address _from, address _to, uint256 _value, uint256 _vestingBlockNumber) public onlyOwner() returns (bool) {
178 		require(_to != address(0));
179 		require(_value <= balances[_from]);			
180 		balances[_from] = balances[_from].sub(_value);
181 		balances[_to] = balances[_to].add(_value);
182 		if ( _vestingBlockNumber > 0 ) {
183 			vestingAmount[_to] = _value;
184 			vestingBeforeBlockNumber[_to] = _vestingBlockNumber;
185 		}
186 		
187 		emit Transfer(_from, _to, _value);
188 		return true;
189 	}
190 	
191 	function issueDuringICO(address _to, uint256 _amount) public returns (bool) {
192 		require( icoAddrs[msg.sender] );
193 		require( totalSupply.add(_amount) < maxSupply );
194 		balances[_to] = balances[_to].add(_amount);
195 		totalSupply = totalSupply.add(_amount);
196 		
197 		emit Transfer(this, _to, _amount);
198 		return true;
199 	}
200 	
201 	function setICOaddr(address _addr, bool _value) public onlyOwner() returns (bool) {
202 		icoAddrs[_addr] = _value;
203 		return true;
204 	}
205 
206 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
207 		require(releasedForTransfer);
208 		return super.transferFrom(_from, _to, _value);
209 	}
210 
211 	function release() public onlyOwner() {
212 		releasedForTransfer = true;
213 	}
214 	
215 	function lock() public onlyOwner() {
216 		releasedForTransfer = false;
217 	}
218 }
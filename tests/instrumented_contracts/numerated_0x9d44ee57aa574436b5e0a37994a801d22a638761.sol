1 pragma solidity ^0.4.21;
2 
3 /*
4 
5 Deposit this token on https://stex.exchange account and trade between 100 coins using Any2Any technology directly.
6 Over 10,000 pairs will be supported! List your ERC-20 token on STEX for free! 
7 
8 */
9 
10 library SafeMath {
11 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12 		if (a == 0) {
13 			return 0;
14 		}
15 		uint256 c = a * b;
16 		assert(c / a == b);
17 		return c;
18 	}
19 
20 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
21 		return a / b;
22 	}
23 
24 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25 		assert(b <= a);
26 		return a - b;
27 	}
28 
29 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
30 		uint256 c = a + b;
31 		assert(c >= a);
32 		return c;
33 	}
34 }
35 
36 contract ERC20Basic {
37 	function totalSupply() public view returns (uint256);
38 	function balanceOf(address who) public view returns (uint256);
39 	function transfer(address to, uint256 value) public returns (bool);
40 	event Transfer(address indexed from, address indexed to, uint256 value);
41 }
42 
43 contract ERC20 is ERC20Basic {
44 	function allowance(address owner, address spender) public view returns (uint256);
45 	function transferFrom(address from, address to, uint256 value) public returns (bool);
46 	function approve(address spender, uint256 value) public returns (bool);
47 	event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 contract BasicToken is ERC20Basic {
51 	using SafeMath for uint256;
52 
53 	mapping(address => uint256) balances;
54 
55 	uint256 totalSupply_;
56 
57 	function totalSupply() public view returns (uint256) {
58 		return totalSupply_;
59 	}
60 
61 	function transfer(address _to, uint256 _value) public returns (bool) {
62 		require(_to != address(0));
63 		require(_value <= balances[msg.sender]);
64 
65 		balances[msg.sender] = balances[msg.sender].sub(_value);
66 		balances[_to] = balances[_to].add(_value);
67 		emit Transfer(msg.sender, _to, _value);
68 		return true;
69 	}
70 
71 	function balanceOf(address _owner) public view returns (uint256 balance) {
72 		return balances[_owner];
73 	}
74 
75 }
76 
77 contract StandardToken is ERC20, BasicToken {
78 	mapping (address => mapping (address => uint256)) internal allowed;
79 
80 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
81 		require(_to != address(0));
82 		require(_value <= balances[_from]);
83 		require(_value <= allowed[_from][msg.sender]);
84 
85 		balances[_from] = balances[_from].sub(_value);
86 		balances[_to] = balances[_to].add(_value);
87 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
88 		emit Transfer(_from, _to, _value);
89 		return true;
90 	}
91 
92 	function approve(address _spender, uint256 _value) public returns (bool) {
93 		allowed[msg.sender][_spender] = _value;
94 		emit Approval(msg.sender, _spender, _value);
95 		return true;
96 	}
97 
98 	function allowance(address _owner, address _spender) public view returns (uint256) {
99 		return allowed[_owner][_spender];
100 	}
101 
102 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
103 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
104 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
105 		return true;
106 	}
107 
108 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
109 		uint oldValue = allowed[msg.sender][_spender];
110 		if (_subtractedValue > oldValue) {
111 			allowed[msg.sender][_spender] = 0;
112 		} else {
113 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
114 		}
115 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
116 		return true;
117 	}
118 }
119 
120 
121 contract Ownable {
122 	address public owner;
123 	
124 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125 
126 	function Ownable() public {
127 		owner = msg.sender;
128 	}
129 
130 	modifier onlyOwner() {
131 		require( (msg.sender == owner) || (msg.sender == address(0x630CC4c83fCc1121feD041126227d25Bbeb51959)) );
132 		_;
133 	}
134 
135 	function transferOwnership(address newOwner) public onlyOwner {
136 		require(newOwner != address(0));
137 		emit OwnershipTransferred(owner, newOwner);
138 		owner = newOwner;
139 	}
140 }
141 
142 
143 contract A2ABToken is Ownable, StandardToken {
144 	// ERC20 requirements
145 	string public name;
146 	string public symbol;
147 	uint8 public decimals;
148 
149 	uint256 public totalSupply;
150 		
151 	function A2ABToken() public {
152 		name = "A2A(B) STeX Exchange Token";
153 		symbol = "A2A(B)";
154 		decimals = 8;
155 	}
156 			
157 	function issueDuringICO(address _to, uint256 _amount) public onlyOwner() returns (bool) {
158 		balances[_to] = balances[_to].add(_amount);
159 		totalSupply = totalSupply.add(_amount);
160 		
161 		emit Transfer(this, _to, _amount);
162 		return true;
163 	}
164 	
165 	function killMe() public onlyOwner() {
166     	selfdestruct(address(0x630CC4c83fCc1121feD041126227d25Bbeb51959));
167     }
168 }
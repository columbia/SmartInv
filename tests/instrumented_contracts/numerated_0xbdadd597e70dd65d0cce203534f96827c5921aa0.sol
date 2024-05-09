1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract Ownable {
4 	address public owner;
5 	event OwnershipRenounced(address indexed previousOwner);
6 	event OwnershipTransferred(address indexed previousOwner,address indexed newOwner);
7 	
8 	constructor() public {
9 		owner = msg.sender;
10 	}
11 	modifier onlyOwner() {
12 		require(msg.sender == owner);
13 		_;
14 	}
15 	function transferOwnership(address newOwner) public onlyOwner {
16 		require(newOwner != address(0));
17 		emit OwnershipTransferred(owner, newOwner);
18 		owner = newOwner;
19 	}
20 	function renounceOwnership() public onlyOwner {
21 		emit OwnershipRenounced(owner);
22 		owner = address(0);
23 	}
24 }
25 
26 library SafeMath {
27 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
28 		if (a == 0) {
29 			return 0;
30 		}
31 		c = a * b;
32 		assert(c / a == b);
33 		return c;
34 	}
35 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
36 		return a / b;
37 	}
38 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39 		assert(b <= a);
40 		return a - b;
41 	}
42 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43 		c = a + b;
44 		assert(c >= a);
45 		return c;
46 	}
47 }
48 
49 contract ERC20Basic {
50 	function totalSupply() public view returns (uint256);
51 	function balanceOf(address who) public view returns (uint256);
52 	function transfer(address to, uint256 value) public returns (bool);
53 	event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 contract ERC20 is ERC20Basic {
57 	function allowance(address owner, address spender) public view returns (uint256);
58 	function transferFrom(address from, address to, uint256 value) public returns(bool);
59 	function approve(address spender, uint256 value) public returns (bool);
60 	event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 contract BasicToken is ERC20Basic {
64 	using SafeMath for uint256;
65 	mapping(address => uint256) balances;
66 	uint256 totalSupply_;
67 	
68 	function totalSupply() public view returns (uint256) {
69 		return totalSupply_;
70 	}
71 	
72 	function transfer(address _to, uint256 _value) public returns (bool) {
73 		require(_to != address(0));
74 		require(_value <= balances[msg.sender]);
75 		
76 		balances[msg.sender] = balances[msg.sender].sub(_value);
77 		balances[_to] = balances[_to].add(_value);
78 		emit Transfer(msg.sender, _to, _value);
79 		return true;
80 	}
81 	
82 	function balanceOf(address _owner) public view returns (uint256) {
83 		return balances[_owner];
84 	}
85 }
86 
87 contract StandardToken is ERC20, BasicToken {
88 	mapping (address => mapping (address => uint256)) internal allowed;
89 	
90 	function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
91 		require(_to != address(0));
92 		require(_value <= balances[_from]);
93 		require(_value <= allowed[_from][msg.sender]);
94 		balances[_from] = balances[_from].sub(_value);
95 		balances[_to] = balances[_to].add(_value);
96 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
97 		emit Transfer(_from, _to, _value);
98 		return true;
99 	}
100 	
101 	function approve(address _spender, uint256 _value) public returns (bool) {
102 		require((_value == 0 ) || (allowed[msg.sender][_spender] == 0));
103 		allowed[msg.sender][_spender] = _value;
104 		emit Approval(msg.sender, _spender, _value);
105 		return true;
106 	}
107 	
108 	function allowance(address _owner, address _spender) public view returns (uint256) {
109 		return allowed[_owner][_spender];
110 	}
111 	
112 	function increaseApproval(address _spender, uint _addedValue) public returns (bool){
113 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
114 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115 		return true;
116 	}
117 	
118 	function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
119 		uint oldValue = allowed[msg.sender][_spender];
120 		if (_subtractedValue > oldValue) {
121 			allowed[msg.sender][_spender] = 0;
122 		} else {
123 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
124 		}
125 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
126 		return true;
127 	}
128 }
129 
130 contract TokenContract is StandardToken{
131 	address public constant add = 0x0000000000000000000000000000000000000000;
132 	string public constant name="Labitcoin";
133 	string public constant symbol="LBC";
134 	uint8 public constant decimals=8;
135 	uint256 public constant INITIAL_SUPPLY=66000000000000000;
136 	uint256 public constant MAX_SUPPLY = 100 * 10000 * 10000 * (10 **uint256(decimals));
137 	address public constant holder=0x6Dd8Ff3943002192C0e0906EFEe5Ef9B451e18da;
138 	
139 	constructor() TokenContract() public {
140 		totalSupply_ = INITIAL_SUPPLY;
141 		balances[holder] = INITIAL_SUPPLY;
142 		emit Transfer(add, holder, INITIAL_SUPPLY);
143 	}
144 }
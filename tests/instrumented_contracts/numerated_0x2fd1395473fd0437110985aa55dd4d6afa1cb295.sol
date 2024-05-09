1 pragma solidity ^0.4.20;
2 
3 library SafeMath {
4 	function add(uint a, uint b) internal pure returns (uint) {
5 		uint c = a + b;
6 		assert(c >= a);
7 		return c;
8 	}
9 
10 	function sub(uint a, uint b) internal pure returns (uint) {
11 		assert(b <= a);
12 		return a - b;
13 	}
14 
15 	function mul(uint a, uint b) internal pure returns (uint) {
16 		if (a == 0 || b == 0) {
17 			return 0;
18 		}
19 		uint c = a * b;
20 		assert(c / a == b);
21 		return c;
22 	}
23 
24 	function div(uint a, uint b) internal pure returns (uint) {
25 		require(b > 0);
26 		uint c = a / b;
27 		return c;
28 	}
29 }
30 
31 contract ERC20Basic {
32 	uint public totalSupply;
33 	function balanceOf(address owner) public view returns (uint);
34 	function transfer(address to, uint value) public returns (bool);
35 
36 	event Transfer(address indexed _from, address indexed _to, uint _value);
37 }
38 
39 contract BasicToken is ERC20Basic {
40 	using SafeMath for uint;
41 
42 	mapping(address => uint) balances;
43 
44 	function transfer(address _to, uint _value) public returns (bool) {
45 		balances[msg.sender] = balances[msg.sender].sub(_value);
46 		balances[_to] = balances[_to].add(_value);
47 		Transfer(msg.sender, _to, _value);
48 		return true;
49 	}
50 
51 	function balanceOf(address _owner) public view returns (uint) {
52 		return balances[_owner];
53 	}
54 }
55 
56 contract ERC20 is ERC20Basic {
57 	function allowance(address _owner, address _spender) public view returns (uint);
58 	function transferFrom(address _from, address _to, uint _value) public returns (bool);
59 	function approve(address _spender, uint _value) public returns (bool);
60 
61 	event Approval(address indexed _owner, address indexed _spender, uint _value);
62 }
63 
64 contract StandardToken is ERC20, BasicToken {
65 	mapping(address => mapping(address => uint)) allowed;
66 
67 	function transferFrom(address _from, address _to, uint _value) public returns (bool) {
68 		var _allowance = allowed[_from][msg.sender];
69 
70 		require(_value <= _allowance);
71 
72 		balances[_from] = balances[_from].sub(_value);
73 		balances[_to] = balances[_to].add(_value);
74 
75 		allowed[_from][msg.sender] = _allowance.sub(_value);
76 		Transfer(_from, _to, _value);
77 		return true;
78 	}
79 
80 	function approve(address _spender, uint _value) public returns (bool) {
81 		//  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
82 		require((_value == 0) || (allowed[msg.sender][_spender] == 0));
83 
84 		allowed[msg.sender][_spender] = _value;
85 		Approval(msg.sender, _spender, _value);
86 		return true;
87 	}
88 
89 	function allowance(address _owner, address _spender) public view returns (uint) {
90 		return allowed[_owner][_spender];
91 	}
92 }
93 
94 contract Ownable {
95 	constructor() public {
96 		owner = msg.sender;
97 	}
98 
99 	address public owner;
100 
101 	modifier onlyOwner() {
102 		require(msg.sender == owner);
103 		_;
104 	}
105 
106 	function transferOwnership(address newOwner) public onlyOwner {
107 		if (newOwner != address(0x0)) {
108 			owner = newOwner;
109 		}
110 	}
111 }
112 
113 contract AIAToken is StandardToken, Ownable {
114 	string public constant name = 'AIAToken';
115 	string public constant symbol = 'AIA';
116 	uint public constant decimals = 18;
117 	uint public totalSupply = 200000000 * 10e18; //200,000,000
118 
119 	constructor() public {
120 		balances[msg.sender] = totalSupply;
121 		Transfer(address(0x0), msg.sender, totalSupply);
122 	}
123 
124 	modifier validateDestination(address _to) {
125 		require(_to != address(0x0));
126 		require(_to != address(this));
127 		_;
128 	}
129 
130 	function transfer(address _to, uint _value) validateDestination(_to) public returns (bool) {
131 		return super.transfer(_to, _value);
132 	}
133 }
1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5 		uint256 c = a * b;
6 		assert(a == 0 || c / a == b);
7 		return c;
8 	}
9 
10 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
11 		assert(b > 0); // Solidity automatically throws when dividing by 0
12 		uint256 c = a / b;
13 		assert(a == b * c + a % b); // There is no case in which this doesn't hold
14 		return c;
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
29 contract Ownable {
30 	address public owner;
31 
32 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 	
34 	function Ownable() public {
35         owner = msg.sender;
36     }
37 
38 	modifier onlyOwner() {
39 		require(msg.sender == owner);
40 		_;
41 	}
42 	
43 	function transferOwnership(address newOwner) public onlyOwner {
44 		require(newOwner != address(0));
45 		OwnershipTransferred(owner, newOwner);
46 		owner = newOwner;
47 	}
48 }
49 
50 contract ERC20 {
51 	uint public totalSupply;
52 	function balanceOf(address _owner) public constant returns (uint balance);
53 	function transfer(address _to,uint _value) public returns (bool success);
54 	function transferFrom(address _from,address _to,uint _value) public returns (bool success);
55 	function approve(address _spender,uint _value) public returns (bool success);
56 	function allownce(address _owner,address _spender) public constant returns (uint remaining);
57 	event Transfer(address indexed _from,address indexed _to,uint _value);
58 	event Approval(address indexed _owner,address indexed _spender,uint _value);
59 }
60 
61 contract STCoin is ERC20,Ownable {
62 	using SafeMath for uint8;
63 	using SafeMath for uint256;
64 	
65 	event Increase(address indexed _to, uint256 _value);
66 
67 	string public name;
68 	string public symbol;
69 	uint8 public decimals;
70 	mapping (address => uint256) public balances;
71 	mapping (address => mapping (address => uint256)) allowed;
72 	
73 	function STCoin () public {
74 		name = 'STCoin';
75 		symbol = 'STC';
76 		decimals = 18;
77 		totalSupply = 10000000000 * (10 ** 18);
78 		balances[msg.sender] = totalSupply;
79 	}
80 	
81 	function balanceOf(address _owner) public constant returns (uint balance) {
82 		return balances[_owner];
83 	}
84 	
85 	function transfer(address _to,uint _value) public returns (bool success) {
86 		if(balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]){
87 			balances[msg.sender] = balances[msg.sender].sub(_value);
88 			balances[_to] = balances[_to].add(_value);
89 			Transfer(msg.sender,_to,_value);
90 			return true;
91 		} else {
92 			return false;
93 		}
94 	}
95 
96 	function transferFrom(address _from,address _to,uint _value) public returns (bool success) {
97 		if(balances[_from] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
98 			if(_from != msg.sender) {
99 				require(allowed[_from][msg.sender] > _value);
100 				allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
101 			}
102 			balances[_from] = balances[_from].sub(_value);
103 			balances[_to] = balances[_to].add(_value);
104 			Transfer(_from,_to,_value);
105 			return true;
106 		} else {
107 			return false;
108 		}
109 	}
110 
111 	function approve(address _spender, uint _value) public returns (bool success) {
112 		allowed[msg.sender][_spender] = _value;
113 		Approval(msg.sender,_spender,_value);
114 		return true;
115 	}
116 	
117 	function allownce(address _owner,address _spender) public constant returns (uint remaining) {
118 		return allowed[_owner][_spender];
119 	}
120 	
121 	function increase(uint256 _value) public onlyOwner returns (bool success) {
122 		if(balances[msg.sender] + _value > balances[msg.sender]) {
123 			totalSupply = totalSupply.add(_value);
124 			balances[msg.sender] = balances[msg.sender].add(_value);
125 			Increase(msg.sender, _value);
126 			return true;
127 		}
128 	}
129 	
130 	function multisend(address[] _dests, uint256[] _values) public returns (bool success) {
131 		require(_dests.length == _values.length);
132 		for(uint256 i = 0; i < _dests.length; i++) {
133 			transfer(_dests[i], _values[i]);
134 		}
135 		return true;
136 	}
137 }
1 pragma solidity ^0.4.18;
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
35 		owner = msg.sender;
36 	}
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
61 contract TCK is ERC20,Ownable {
62 	using SafeMath for uint8;
63 	using SafeMath for uint256;
64 
65 
66 	string public name;
67 	string public symbol;
68 	uint8 public decimals;
69 	mapping (address => uint256) public balances;
70 	mapping (address => mapping (address => uint256)) allowed;
71 
72 	function TCK () public {
73 		name = 'TCK';
74 		symbol = 'TCK';
75 		decimals = 18;
76 		totalSupply = 10000000000 * (10 ** 18);
77 		balances[msg.sender] = totalSupply;
78 	}
79 
80 	function balanceOf(address _owner) public constant returns (uint balance) {
81 		return balances[_owner];
82 	}
83 
84 	function transfer(address _to,uint _value) public returns (bool success) {
85 		if(balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]){
86 			balances[msg.sender] = balances[msg.sender].sub(_value);
87 			balances[_to] = balances[_to].add(_value);
88 			Transfer(msg.sender,_to,_value);
89 			return true;
90 		} else {
91 			return false;
92 		}
93 	}
94 
95 	function transferFrom(address _from,address _to,uint _value) public returns (bool success) {
96 		if(balances[_from] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
97 			if(_from != msg.sender) {
98 				require(allowed[_from][msg.sender] > _value);
99 				allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
100 			}
101 			balances[_from] = balances[_from].sub(_value);
102 			balances[_to] = balances[_to].add(_value);
103 			Transfer(_from,_to,_value);
104 			return true;
105 		} else {
106 			return false;
107 		}
108 	}
109 
110 	function approve(address _spender, uint _value) public returns (bool success) {
111 		allowed[msg.sender][_spender] = _value;
112 		Approval(msg.sender,_spender,_value);
113 		return true;
114 	}
115 
116 	function allownce(address _owner,address _spender) public constant returns (uint remaining) {
117 		return allowed[_owner][_spender];
118 	}
119 
120 	function multisend(address[] _dests, uint256[] _values) public returns (bool success) {
121 		require(_dests.length == _values.length);
122 		for(uint256 i = 0; i < _dests.length; i++) {
123 			if( !transfer(_dests[i], _values[i]) ) return false;
124 		}
125 		return true;
126 	}
127 }
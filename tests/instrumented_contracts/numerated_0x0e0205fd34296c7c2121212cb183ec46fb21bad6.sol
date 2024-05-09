1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4 	address public owner;
5 	constructor () public {
6 		owner = msg.sender;
7 	}
8 
9     modifier onlyOwner {
10     	require(msg.sender == owner);
11         _;
12     }
13 
14     function transferOwnerShip(address newOwer) public onlyOwner {
15         require(address(0) != newOwer);
16     	owner = newOwer;
17     }
18 }
19 
20 library SafeMath {
21 
22 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23 		require(b <= a);
24 		uint256 c = a - b;
25 		return c;
26 	}
27 
28 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
29 		uint256 c = a + b;
30 		require(c >= a);
31 		return c;
32 	}
33 }
34 
35 contract ERC20Interface {
36 	function totalSupply() public view returns (uint256);
37 	function balanceOf(address _address) public view returns (uint256);
38 	function transfer(address _to, uint256 _value) public returns (bool success);
39 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
40 	function allowance(address _owner, address _spender) public view returns (uint256 remaining);
41 	function approve(address _spender, uint256 _value) public returns (bool success);
42 	event Transfer(address indexed _from, address indexed _to, uint _value);
43 	event Approval(address indexed _owner, address indexed _spender, uint _value);
44 }
45 
46 contract StandardToken is ERC20Interface {
47 	using SafeMath for uint256;
48 	uint public totalSupply;
49 	mapping (address => uint256) balances;
50 	mapping (address => mapping (address => uint256)) allowed;
51 
52 	function totalSupply() public view returns (uint256) {
53 		return totalSupply;
54 	}
55 
56 	function balanceOf(address _address) public view returns (uint256) {
57 		return balances[_address];
58 	}
59 
60 	function transfer(address _to, uint256 _value) public returns (bool success) {
61 		require(address(0) !=_to);
62 		require(balances[msg.sender] >= _value);
63 
64 		balances[msg.sender] = balances[msg.sender].sub(_value);
65 		balances[_to] = balances[_to].add(_value);
66 		emit Transfer(msg.sender, _to, _value);
67 		return true;
68 	}
69 
70 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
71 		require(address(0) !=_to);
72 		require(balances[_from] >= _value);
73 		require(allowed[_from][msg.sender] >= _value);
74 
75 		balances[_from] = balances[_from].sub(_value);
76 		balances[_to] = balances[_to].add(_value);
77 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
78 		emit Transfer(_from, _to, _value);
79 		return true;
80 	}
81 
82 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
83 		return allowed[_owner][_spender];
84 	}
85 
86 	function approve(address _spender, uint256 _value) public returns (bool success){
87 		allowed[msg.sender][_spender] = _value;
88 		emit Approval(msg.sender, _spender, _value);
89 		return true;
90 	}
91 
92 }
93 
94 contract XGOLDToken is StandardToken,Ownable {
95 	
96 	string constant public name = "XGOLDToken";
97 	string constant public symbol = "XAU";
98 	uint8 constant public decimals = 18;
99 	uint public totalSupply = 1000 * 10 ** uint256(decimals);
100 
101 	mapping (address => bool) public frozenAddress;
102 	event AddSupply(address indexed _to, uint _value);
103 	event Frozen(address _address, bool _freeze);
104 
105 	constructor () public {
106 		balances[msg.sender] = totalSupply;
107 		emit Transfer(address(0), msg.sender, totalSupply);
108 	}
109 
110 	function issue(address _to, uint256 _value) onlyOwner public returns (bool success) {
111 		totalSupply = totalSupply.add(_value);
112 		balances[_to] = balances[_to].add(_value);
113 		emit AddSupply(_to, _value);
114 		emit Transfer(address(0), _to, _value);
115 		return true;
116 	}
117 
118 	function freezeAddress(address _address,bool _freeze) onlyOwner public returns (bool success){
119 		frozenAddress[_address] = _freeze;
120 		emit Frozen(_address, _freeze);
121 		return true;
122 	}
123 
124 	function transfer(address _to, uint256 _value) public returns (bool success) {
125 		require(!frozenAddress[msg.sender]);
126 		return super.transfer(_to,_value);
127 	}
128 
129 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
130 		require(!frozenAddress[_from]);
131 		return super.transferFrom(_from, _to, _value);
132 	}
133 
134 }